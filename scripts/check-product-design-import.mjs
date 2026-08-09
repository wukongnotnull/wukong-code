#!/usr/bin/env node

import { createHash } from "node:crypto";
import { lstat, readFile, readdir } from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const ALGORITHM = "sha256-path-content-v1";
const IGNORED_DIRECTORIES = new Set(["__pycache__", ".vite", "dist", "node_modules"]);

function comparePaths(left, right) {
  return left < right ? -1 : left > right ? 1 : 0;
}

function usage() {
  return `Usage: node scripts/check-product-design-import.mjs [--root PATH] [--print]

Verify that the Product Design files listed in product-design.lock.json match
the recorded integrated-content digest. Use --print to emit the current digest
without comparing it to the lock.`;
}

function parseArgs(argv) {
  let root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
  let printOnly = false;

  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];
    if (argument === "--root") {
      const value = argv[index + 1];
      if (!value) {
        throw new Error("--root requires a path");
      }
      root = path.resolve(value);
      index += 1;
    } else if (argument === "--print") {
      printOnly = true;
    } else if (argument === "--help" || argument === "-h") {
      process.stdout.write(`${usage()}\n`);
      process.exit(0);
    } else {
      throw new Error(`unknown argument: ${argument}`);
    }
  }

  return { root, printOnly };
}

function validateRelativeRoot(relativeRoot) {
  if (typeof relativeRoot !== "string" || relativeRoot.length === 0) {
    throw new Error("every imported root must be a non-empty string");
  }
  if (
    path.posix.isAbsolute(relativeRoot)
    || path.posix.normalize(relativeRoot) !== relativeRoot
    || relativeRoot === "."
    || relativeRoot.startsWith("../")
    || relativeRoot.includes("\\")
  ) {
    throw new Error(`invalid imported root: ${relativeRoot}`);
  }
}

function ignoreEntry(name, isDirectory) {
  if (isDirectory) {
    return IGNORED_DIRECTORIES.has(name);
  }
  return name === ".DS_Store" || name.endsWith(".pyc");
}

async function collectFiles(root, relativePath, files) {
  const absolutePath = path.join(root, ...relativePath.split("/"));
  const metadata = await lstat(absolutePath);

  if (metadata.isSymbolicLink()) {
    throw new Error(`symbolic links are not supported in imported content: ${relativePath}`);
  }
  if (metadata.isFile()) {
    if (files.has(relativePath)) {
      throw new Error(`overlapping imported roots include the same file twice: ${relativePath}`);
    }
    files.add(relativePath);
    return;
  }
  if (!metadata.isDirectory()) {
    throw new Error(`unsupported imported content type: ${relativePath}`);
  }

  const entries = await readdir(absolutePath, { withFileTypes: true });
  entries.sort((left, right) => comparePaths(left.name, right.name));
  for (const entry of entries) {
    if (ignoreEntry(entry.name, entry.isDirectory())) {
      continue;
    }
    await collectFiles(root, `${relativePath}/${entry.name}`, files);
  }
}

async function calculateDigest(root, importedRoots) {
  if (!Array.isArray(importedRoots) || importedRoots.length === 0) {
    throw new Error("product-design.lock.json must declare non-empty imported_roots");
  }

  const files = new Set();
  for (const relativeRoot of importedRoots) {
    validateRelativeRoot(relativeRoot);
    await collectFiles(root, relativeRoot, files);
  }

  const sortedFiles = [...files].sort(comparePaths);
  const digest = createHash("sha256");
  digest.update(`${ALGORITHM}\0`);
  for (const relativeFile of sortedFiles) {
    const contents = await readFile(path.join(root, ...relativeFile.split("/")));
    digest.update(relativeFile);
    digest.update("\0");
    digest.update(String(contents.byteLength));
    digest.update("\0");
    digest.update(contents);
    digest.update("\0");
  }

  return { value: digest.digest("hex"), fileCount: sortedFiles.length };
}

async function main() {
  const { root, printOnly } = parseArgs(process.argv.slice(2));
  const lockPath = path.join(root, "product-design.lock.json");
  const lock = JSON.parse(await readFile(lockPath, "utf8"));
  const actual = await calculateDigest(root, lock.imported_roots);

  if (printOnly) {
    process.stdout.write(`${actual.value}\n`);
    return;
  }

  const expected = lock.integrity;
  if (expected?.algorithm !== ALGORITHM) {
    throw new Error(`integrity algorithm must be ${ALGORITHM}`);
  }
  if (!/^[0-9a-f]{64}$/.test(expected.value ?? "")) {
    throw new Error("integrity value must be a lowercase SHA-256 digest");
  }
  if (expected.value !== actual.value) {
    throw new Error(
      `Product Design import integrity mismatch: expected ${expected.value}, got ${actual.value}`,
    );
  }

  process.stdout.write(
    `Product Design import integrity OK (${actual.fileCount} files): ${actual.value}\n`,
  );
}

main().catch((error) => {
  process.stderr.write(`${error.message}\n`);
  process.exitCode = 1;
});
