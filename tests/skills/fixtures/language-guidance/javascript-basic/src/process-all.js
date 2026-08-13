export async function processAll(raw, processor, signal) {
  if (!Array.isArray(raw) || !Array.from(raw).every((value) => typeof value === "string")) {
    throw new TypeError("expected an array of strings");
  }

  return Promise.all(raw.map((value) => processor(value, { signal })));
}
