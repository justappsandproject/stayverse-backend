import { axiosInstance } from "@/config/axios.config";
import { fetchPaginatedData } from "@/lib/fetch-data.utils";
import { ServiceStatus } from "@/types";
import { Chef } from "@/types/chef";
import { toast } from "sonner";


export const ChefService = {
    getAllChefs: async (params?: { page?: number, limit?: number, searchTerm?: string, status?: `${ServiceStatus}` }) => {
        const { page = 1, limit = 10, searchTerm, status } = params || {};
        return fetchPaginatedData<Chef[]>({
            url: '/chef/all',
            params: { page, limit, searchTerm, status },
            failedMessage: 'Failed to fetch chefs',
        });
    },
    updateChefStatus: async (chefId: string, status: ServiceStatus) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/chef/${chefId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Chef status updated successfully.');
                return data?.data as Chef;
            } else {
                toast.warning(data?.message);
            }
        } catch {
            toast.error('Failed to update chef status');
        }
    }
}
