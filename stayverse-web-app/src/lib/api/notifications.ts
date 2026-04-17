import { api } from "@/lib/api/http";
import { unwrapResponseData } from "@/lib/api/response";
import type { CuratedMessage } from "@/lib/types";

type CuratedResponse = {
  data?: CuratedMessage[];
};

export async function getCuratedMessages(page = 1, limit = 20) {
  const response = await api.get<CuratedResponse>("/notification/curated", {
    params: { page, limit },
  });
  const payload = unwrapResponseData<CuratedResponse>(response.data);
  return payload?.data ?? [];
}
