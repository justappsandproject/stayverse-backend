import { api } from "@/lib/api/http";
import { unwrapResponseData } from "@/lib/api/response";
import type { FavoriteRecord, PaginatedResponse } from "@/lib/types";

function normalizeFavorites(
  payload: PaginatedResponse<FavoriteRecord> | FavoriteRecord[] | { favorites?: FavoriteRecord[] }
) {
  if (Array.isArray(payload)) return payload;
  const mapped = payload as PaginatedResponse<FavoriteRecord> & { favorites?: FavoriteRecord[] };
  if (Array.isArray(mapped.data)) return mapped.data;
  if (Array.isArray(mapped.docs)) return mapped.docs;
  if (Array.isArray(mapped.items)) return mapped.items;
  if (Array.isArray(mapped.favorites)) return mapped.favorites;
  return [];
}

export async function getFavorites() {
  const response = await api.get<
    PaginatedResponse<FavoriteRecord> | FavoriteRecord[] | { favorites?: FavoriteRecord[] }
  >("/favorites/user");
  return normalizeFavorites(unwrapResponseData(response.data));
}
