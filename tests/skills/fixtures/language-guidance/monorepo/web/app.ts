export const appName: string = "fixture";

export function readLabels(raw: unknown): string[] {
  if (!Array.isArray(raw) || !raw.every((value) => typeof value === "string")) {
    throw new TypeError("expected string labels");
  }
  return raw;
}
