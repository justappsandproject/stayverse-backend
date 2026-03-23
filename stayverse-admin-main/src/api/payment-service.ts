import { axiosInstance } from "@/config/axios.config";
import { fetchPaginatedData } from "@/lib/fetch-data.utils";
import { AdminEscrowStatus } from "@/types";
import { toast } from "sonner";

export interface Transaction {
    _id: string,
    reference: string,
    amount: number,
    type: 'credit' | 'debit',
    status: 'pending' | 'successful' | 'failed',
    userId: string,
    description: string,
    createdAt: string,
    updatedAt: string,
}

export interface Escrow {
    _id: string,
    bookingId: string,
    userId: string,
    totalAmount: number,
    amountReleased: number,
    lastReleasedDay: number,
    status: 'hold' | 'partial' | 'completed',
    payoutType: 'daily' | 'whole',
    adminEscrowStatus: AdminEscrowStatus,
    createdAt: string,
    updatedAt: string,
}

interface GetEscrowParams {
    page: number,
    limit: number,
    status?: 'hold' | 'partial' | 'completed',
    payoutType?: 'daily' | 'whole',
    adminEscrowStatus?: AdminEscrowStatus | 'all',
    searchTerm?: string
}

export const PaymentService = {
    getAllTransactions: async ({ page, limit }: { page: number, limit: number }) => {
        return fetchPaginatedData<Transaction[]>({
            url: '/payments/admin',
            params: { page, limit },
            failedMessage: 'Failed to fetch transactions',
        });
    },
    getAllEscrows: async ({ page, limit, status, payoutType, adminEscrowStatus, searchTerm }: GetEscrowParams) => {
        return fetchPaginatedData<Escrow[]>({
            url: '/payments/escrow',
            params: { page, limit, status, payoutType, adminEscrowStatus, searchTerm },
            failedMessage: 'Failed to fetch escrows',
        });
    },
    updateAdminEscrowStatus: async (escrowId: string, status: AdminEscrowStatus) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/payments/escrow/${escrowId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Escrow status updated successfully.');
                return data?.data as Escrow;
            } else {
                toast.warning(data?.message);
            }
        } catch {
            toast.error('Failed to update escrow status');
        }
    },
}