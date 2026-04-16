import { api } from "@/lib/api/http";
import { unwrapResponseData } from "@/lib/api/response";
import type { PaginatedResponse, WalletTransaction } from "@/lib/types";

function normalizeTransactions(
  payload: PaginatedResponse<WalletTransaction> | WalletTransaction[] | { transactions?: WalletTransaction[] }
) {
  if (Array.isArray(payload)) return payload;
  const mapped = payload as PaginatedResponse<WalletTransaction> & {
    transactions?: WalletTransaction[];
  };
  if (Array.isArray(mapped.data)) return mapped.data;
  if (Array.isArray(mapped.docs)) return mapped.docs;
  if (Array.isArray(mapped.items)) return mapped.items;
  if (Array.isArray(mapped.transactions)) return mapped.transactions;
  return [];
}

export async function getWalletTransactions() {
  const response = await api.get<
    PaginatedResponse<WalletTransaction> | WalletTransaction[] | { transactions?: WalletTransaction[] }
  >("/payments");
  return normalizeTransactions(unwrapResponseData(response.data));
}

export async function fundWallet(amount: number) {
  const response = await api.post("/payments/fund-wallet", { amount });
  return unwrapResponseData<{ authorizationUrl?: string; reference?: string }>(response.data);
}

export async function requestWithdrawal(payload: {
  fullName: string;
  accountNumber: string;
  bankCode: string;
  amount: number;
  password: string;
}) {
  const response = await api.post("/payments/withdraw", payload);
  return unwrapResponseData(response.data);
}
