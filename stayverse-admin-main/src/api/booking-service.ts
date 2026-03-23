import { fetchPaginatedData } from "@/lib/fetch-data.utils";
import { Booking } from "@/types/booking";

interface BookingParams {
    page?: number;
    limit?: number;
    serviceType?: 'chef' | 'apartment' | 'ride';
    status?: 'pending' | 'rejected' | 'accepted' | 'completed';
    startDate?: string;
    endDate?: string;
}

export const BookingService = {
    getAllBookings: async (params?: BookingParams) => {
        const { page = 1, limit = 10, ...restParams } = params || {};
        return fetchPaginatedData<Booking[]>({
            url: '/booking/admin',
            params: { page, limit, ...restParams },
            failedMessage: 'Failed to fetch bookings',
        });
    },
    getBookingById: async (id: string) => {
        return fetchPaginatedData<Booking[]>({
            url: `/booking/${id}`,
            failedMessage: 'Failed to fetch booking',
        });
    },
}