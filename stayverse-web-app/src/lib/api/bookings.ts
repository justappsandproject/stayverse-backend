import { api } from "@/lib/api/http";
import { unwrapResponseData } from "@/lib/api/response";
import type { AppRole, BookingRecord, PaginatedResponse } from "@/lib/types";

function normalizeBookings(payload: PaginatedResponse<BookingRecord> | BookingRecord[]) {
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.data)) return payload.data;
  if (Array.isArray(payload.docs)) return payload.docs;
  if (Array.isArray(payload.items)) return payload.items;
  return [];
}

export async function getBookings(role: AppRole) {
  const endpoint = role === "user" ? "/booking/user" : "/booking/agent";
  const response = await api.get<PaginatedResponse<BookingRecord> | BookingRecord[]>(endpoint);
  return normalizeBookings(unwrapResponseData(response.data));
}
