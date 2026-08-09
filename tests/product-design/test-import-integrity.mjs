import assert from "node:assert/strict";
import { mkdtemp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { spawnSync } from "node:child_process";
import test from "node:test";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");
const checker = path.join(repoRoot, "scripts/check-product-design-import.mjs");

function runChecker(root, ...args) {
  return spawnSync(process.execPath, [checker, "--root", root, ...args], {
    cwd: repoRoot,
    encoding: "utf8",
  });
}

test("Product Design import lock verifies exact integrated content and detects drift", async () => {
  const checkout = runChecker(repoRoot);
  assert.equal(checkout.status, 0, checkout.stderr || checkout.stdout);

  const fixtureRoot = await mkdtemp(path.join(tmpdir(), "product-design-integrity-"));
  try {
    await mkdir(path.join(fixtureRoot, "skills/product-design"), { recursive: true });
    await mkdir(path.join(fixtureRoot, "references"), { recursive: true });
    await writeFile(path.join(fixtureRoot, "skills/product-design/SKILL.md"), "router\n");
    await writeFile(path.join(fixtureRoot, "references/contract.md"), "contract\n");

    const lockPath = path.join(fixtureRoot, "product-design.lock.json");
    const lock = {
      imported_roots: [
        "skills/product-design",
        "references/contract.md",
      ],
      integrity: {
        algorithm: "sha256-path-content-v1",
        value: "0".repeat(64),
      },
    };
    await writeFile(lockPath, `${JSON.stringify(lock, null, 2)}\n`);

    const printed = runChecker(fixtureRoot, "--print");
    assert.equal(printed.status, 0, printed.stderr || printed.stdout);
    lock.integrity.value = printed.stdout.trim();
    await writeFile(lockPath, `${JSON.stringify(lock, null, 2)}\n`);

    const pristine = runChecker(fixtureRoot);
    assert.equal(pristine.status, 0, pristine.stderr || pristine.stdout);

    const skillPath = path.join(fixtureRoot, "skills/product-design/SKILL.md");
    await writeFile(skillPath, `${await readFile(skillPath, "utf8")}unreviewed drift\n`);

    const drifted = runChecker(fixtureRoot);
    assert.notEqual(drifted.status, 0);
    assert.match(drifted.stderr, /integrity mismatch/i);
  } finally {
    await rm(fixtureRoot, { recursive: true, force: true });
  }
});
