import { fetchPaginatedData } from "@/lib/fetch-data.utils"
import { ServiceStatus } from "@/types";
import { Ride } from "@/types/ride";
import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export const RideService = {
    getAllRides: async (params?: { page?: number, limit?: number, status?: `${ServiceStatus}` | 'all' }) => {
        const { page = 1, limit = 10, status } = params || {};
        const queryParams: any = { page, limit };
        if (status && status !== 'all') {
            queryParams.status = status;
        }

        return fetchPaginatedData<Ride[]>({
            url: '/ride/admin/all',
            params: queryParams,
            failedMessage: 'Failed to fetch rides',
        });
    },

    updateRideStatus: async (rideId: string, status: ServiceStatus | string) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/ride/${rideId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Ride status updated successfully.');
                return data?.data as Ride;
            } else {
                toast.warning(data?.message || 'Failed to update ride status');
            }
        } catch (error: any) {
            toast.error(error?.response?.data?.message || 'Failed to update ride status');
        }
    }
}
