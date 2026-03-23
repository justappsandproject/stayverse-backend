export function stripEmptyFields(dto: Record<string, any>) {
  return Object.fromEntries(
    Object.entries(dto).filter(
      ([_, value]) =>
        value !== undefined &&
        value !== null &&
        value !== '' &&
        !(Array.isArray(value) && value.length === 0)
    )
  );
}
