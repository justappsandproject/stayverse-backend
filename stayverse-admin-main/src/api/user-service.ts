import { fetchPaginatedData } from "@/lib/fetch-data.utils";
import { User } from "@/types/user";

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
}
