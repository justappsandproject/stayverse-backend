type ApiEnvelope<T> = {
  statusCode?: number;
  message?: string;
  data?: T;
  error?: string | string[] | null;
};

export function unwrapResponseData<T>(payload: T | ApiEnvelope<T>): T {
  if (payload && typeof payload === "object" && "data" in (payload as ApiEnvelope<T>)) {
    const wrapped = payload as ApiEnvelope<T>;
    return (wrapped.data ?? ({} as T)) as T;
  }
  return payload as T;
}
