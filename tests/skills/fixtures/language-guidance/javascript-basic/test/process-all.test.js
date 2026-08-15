import assert from "node:assert/strict";
import test from "node:test";

import { processAll } from "../src/process-all.js";

test("preserves input order when processors settle out of order", async () => {
  const releases = new Map();
  const processor = (value, options) =>
    new Promise((resolve) => {
      releases.set(value, () => resolve({ value: value.toUpperCase(), options }));
    });
  const controller = new AbortController();

  const resultPromise = processAll(["first", "second"], processor, controller.signal);
  releases.get("second")();
  releases.get("first")();

  assert.deepEqual(await resultPromise, [
    { value: "FIRST", options: { signal: controller.signal } },
    { value: "SECOND", options: { signal: controller.signal } },
  ]);
});

test("rejects non-string external values before invoking the processor", async () => {
  let calls = 0;

  await assert.rejects(
    processAll(["valid", 3], () => {
      calls += 1;
    }),
    { name: "TypeError", message: "expected an array of strings" },
  );
  assert.equal(calls, 0);
});

test("rejects sparse arrays before invoking the processor", async () => {
  let calls = 0;

  await assert.rejects(
    processAll(new Array(1), () => {
      calls += 1;
    }),
    { name: "TypeError", message: "expected an array of strings" },
  );
  assert.equal(calls, 0);
});

test("preserves processor rejection identity", async () => {
  const failure = new Error("processor failed");

  await assert.rejects(
    processAll(["first", "second"], (value) =>
      value === "second" ? Promise.reject(failure) : Promise.resolve(value),
    ),
    (error) => error === failure,
  );
});
