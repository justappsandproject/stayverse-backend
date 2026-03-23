import { fetchPaginatedData } from "@/lib/fetch-data.utils"
import { ServiceStatus } from "@/types";
import { Apartment } from "@/types/apartment";
import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export const ApartmentService = {
    getAllApartments: async (params?: { page?: number, limit?: number, status?: `${ServiceStatus}` | 'all' }) => {
        const { page = 1, limit = 10, status } = params || {};
        const queryParams: any = { page, limit };
        if (status && status !== 'all') {
            queryParams.status = status;
        }

        return fetchPaginatedData<Apartment[]>({
            url: '/apartment/admin/all',
            params: queryParams,
            failedMessage: 'Failed to fetch apartments',
        });
    },

    updateApartmentStatus: async (apartmentId: string, status: ServiceStatus | string) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/apartment/${apartmentId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Apartment status updated successfully.');
                return data?.data as Apartment;
            } else {
                toast.warning(data?.message || 'Failed to update apartment status');
            }
        } catch (error: any) {
            toast.error(error?.response?.data?.message || 'Failed to update apartment status');
        }
    }
}
