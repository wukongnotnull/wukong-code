import { processAll } from "./process-all";

export async function fixtureCasePreservesInputOrder(): Promise<void> {
  const result = await processAll(["slow", "fast"], async (value) => {
    if (value === "slow") {
      await Promise.resolve();
      await Promise.resolve();
    }
    return value.toUpperCase();
  });

  if (result[0] !== "SLOW" || result[1] !== "FAST") {
    throw new Error("processAll preserves input order");
  }
}

export async function fixtureCaseRejectsInvalidRuntimeInput(): Promise<void> {
  let rejected = false;
  try {
    await processAll({ value: "not-an-array" }, async (value) => value);
  } catch (error: unknown) {
    rejected = error instanceof TypeError;
  }

  if (!rejected) {
    throw new Error("processAll validates unknown input at runtime");
  }
}
