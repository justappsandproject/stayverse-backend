import fetchData from "@/lib/fetch-data.utils"


export interface DashboardMetrics {
    totalApartments: number,
    totalRides: number,
    totalChefs: number,
    totalBookings: number,
    totalEarnings: number
}

export const MetricsService = {
    getDashboardMetrics: async () => {
        return fetchData<DashboardMetrics>({
            url: '/metric/dashboard',
            failedMessage: 'Failed to fetch dashboard metrics',
            fallback: {
                totalApartments: 0,
                totalRides: 0,
                totalChefs: 0,
                totalBookings: 0,
                totalEarnings: 0,
            } as DashboardMetrics,
        });
    },
}