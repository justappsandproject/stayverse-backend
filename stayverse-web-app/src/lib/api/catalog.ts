import { api } from "@/lib/api/http";
import { unwrapResponseData } from "@/lib/api/response";
import type { ChefListing, PaginatedResponse, ServiceListing } from "@/lib/types";

function extractList<T>(
  payload: PaginatedResponse<T> | T[] | { apartments?: T[]; rides?: T[] }
) {
  if (Array.isArray(payload)) return payload;
  const mapped = payload as PaginatedResponse<T> & { apartments?: T[]; rides?: T[] };
  if (Array.isArray(mapped.apartments)) return mapped.apartments;
  if (Array.isArray(mapped.rides)) return mapped.rides;
  if (Array.isArray(mapped.data)) return mapped.data;
  if (Array.isArray(mapped.docs)) return mapped.docs;
  if (Array.isArray(mapped.items)) return mapped.items;
  return [];
}

function extractChefList(
  payload: PaginatedResponse<ChefListing> | ChefListing[] | { chefs?: ChefListing[] }
) {
  if (Array.isArray(payload)) return payload;
  const mapped = payload as PaginatedResponse<ChefListing> & { chefs?: ChefListing[] };
  if (Array.isArray(mapped.chefs)) return mapped.chefs;
  if (Array.isArray(mapped.data)) return mapped.data;
  if (Array.isArray(mapped.docs)) return mapped.docs;
  if (Array.isArray(mapped.items)) return mapped.items;
  return [];
}

export async function getApartments() {
  const response = await api.get<PaginatedResponse<ServiceListing> | ServiceListing[]>(
    "/apartment"
  );
  return extractList(unwrapResponseData(response.data));
}

export async function getRides() {
  const response = await api.get<PaginatedResponse<ServiceListing> | ServiceListing[]>("/ride");
  return extractList(unwrapResponseData(response.data));
}

export async function getChefs() {
  const response = await api.get<
    PaginatedResponse<ChefListing> | ChefListing[] | { chefs?: ChefListing[] }
  >("/chef");
  return extractChefList(unwrapResponseData(response.data));
}
