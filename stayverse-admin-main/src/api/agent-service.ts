import { axiosInstance } from "@/config/axios.config";
import { fetchData, fetchPaginatedData } from "@/lib/fetch-data.utils"
import { ServiceStatus, ServiceType } from "@/types";
import { Agent } from "@/types/agent";
import { Apartment } from "@/types/apartment";
import { Ride } from "@/types/ride";
import { toast } from "sonner";


export const AgentService = {
    getAllAgents: async (params?: { page?: number, limit?: number, serviceType?: `${ServiceType}`, searchTerm?: string, isEmailVerified?: 'true' | 'false' }) => {
        const { page = 1, limit = 10, serviceType, searchTerm, isEmailVerified } = params || {};
        return fetchPaginatedData<Agent[], { totalActive: number, totalInactive: number }>({
            url: '/agents/all',
            params: { page, limit, serviceType, searchTerm, isEmailVerified },
            failedMessage: 'Failed to fetch agents',
        });
    },
    getAgentById: async (agentId: string) => {
        return fetchData<Agent & { completedBookings: number, totalEarnings: number }>({
            url: `/agents/${agentId}`,
            failedMessage: 'Failed to fetch agent',
        });
    },
    getAgentApartmentListing: async (agentId: string, params?: { page?: number, limit?: number, searchTerm?: string, status?: `${ServiceStatus}` }) => {
        const { page = 1, limit = 10, searchTerm, status } = params || {};
        return fetchPaginatedData<Apartment[]>({
            url: `/agents/${agentId}/apartments`,
            params: { page, limit, searchTerm, status },
            failedMessage: 'Failed to fetch agent apartments',
        });
    },
    getAgentRideListing: async (agentId: string, params?: { page?: number, limit?: number, searchTerm?: string, status?: `${ServiceStatus}` }) => {
        const { page = 1, limit = 10, searchTerm, status } = params || {};
        return fetchPaginatedData<Ride[]>({
            url: `/agents/${agentId}/rides`,
            params: { page, limit, searchTerm, status },
            failedMessage: 'Failed to fetch agent rides',
        });
    },
    updateApartmentStatus: async (apartmentId: string, status: ServiceStatus) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/apartment/${apartmentId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Apartment status updated successfully.');
                return data?.data as Apartment;
            } else {
                toast.warning(data?.message);
            }
        } catch {
            toast.error('Failed to update apartment status');
        }
    },
    updateRideStatus: async (rideId: string, status: ServiceStatus) => {
        try {
            const { data, status: responseStatus } = await axiosInstance.patch(`/ride/${rideId}/status`, { status });
            if (responseStatus === 200) {
                toast.success('Ride status updated successfully.');
                return data?.data as Ride;
            } else {
                toast.warning(data?.message);
            }
        } catch {
            toast.error('Failed to update ride status');
        }
    },
    updateAgentKycStatus: async (userId: string, kycStatus: "verified" | "declined") => {
        try {
            const { data, status } = await axiosInstance.patch(`/users/${userId}/kyc-status`, { kycStatus });
            if (status === 200) {
                toast.success(`Agent ${kycStatus === "verified" ? "approved" : "declined"} successfully.`);
                return data?.data;
            }
            toast.warning(data?.message || 'Unable to update agent KYC status.');
        } catch {
            toast.error('Failed to update agent KYC status');
        }
        return null;
    }
}
