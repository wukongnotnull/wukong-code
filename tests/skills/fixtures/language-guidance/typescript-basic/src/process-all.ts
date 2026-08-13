export type Processor = (
  value: string,
  signal?: AbortSignal,
) => Promise<string>;

export async function processAll(
  raw: unknown,
  processor: Processor,
  signal?: AbortSignal,
): Promise<string[]> {
  if (!Array.isArray(raw) || !raw.every((value) => typeof value === "string")) {
    throw new TypeError("expected an array of strings");
  }

  return Promise.all(raw.map((value) => processor(value, signal)));
}
