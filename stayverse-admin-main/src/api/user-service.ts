import { fetchPaginatedData } from "@/lib/fetch-data.utils";
import { User } from "@/types/user";
import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export const UserService = {
    // Get all users
    getAllUsers: async (params?: { page?: number, limit?: number, searchTerm?: string, isEmailVerified?: 'true' | 'false' }) => {
        const { page = 1, limit = 10, searchTerm, isEmailVerified } = params || {};
        return fetchPaginatedData<User[]>({
            url: '/users/all',
            params: { page, limit, searchTerm, isEmailVerified },
            failedMessage: 'Failed to fetch users',
        });
    },
    updateKycStatus: async (userId: string, kycStatus: "verified" | "declined") => {
        try {
            const { data, status } = await axiosInstance.patch(`/users/${userId}/kyc-status`, { kycStatus });
            if (status === 200) {
                toast.success(`User ${kycStatus === "verified" ? "approved" : "declined"} successfully.`);
                return data?.data as User;
            }
            toast.warning(data?.message || "Unable to update KYC status.");
        } catch {
            toast.error("Failed to update user KYC status.");
        }
        return null;
    }
}
