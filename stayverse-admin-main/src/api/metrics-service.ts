import { axiosInstance } from "@/config/axios.config";
import { readMetricsCache, writeMetricsCache } from "@/lib/metrics-cache";
import { toast } from "sonner";

export interface DashboardMetrics {
  totalApartments: number;
  totalRides: number;
  totalChefs: number;
  totalBookings: number;
  totalEarnings: number;
}

const FALLBACK: DashboardMetrics = {
  totalApartments: 0,
  totalRides: 0,
  totalChefs: 0,
  totalBookings: 0,
  totalEarnings: 0,
};

let inFlight: Promise<DashboardMetrics> | null = null;

async function fetchFromApi(silent = false): Promise<DashboardMetrics> {
  try {
    const { data, status } = await axiosInstance.get("/metric/dashboard");
    if (status === 200 && data?.data) {
      const metrics = data.data as DashboardMetrics;
      writeMetricsCache(metrics);
      return metrics;
    }
    if (!silent) {
      toast.warning(data?.message || "Failed to fetch dashboard metrics");
    }
  } catch (error: unknown) {
    if (!silent) {
      toast.error("Failed to fetch dashboard metrics");
    }
    console.error("/metric/dashboard error ->", error);
  }
  return readMetricsCache() ?? FALLBACK;
}

export const MetricsService = {
  getCachedMetrics: readMetricsCache,

  /** Fetch metrics; returns cache immediately when available unless forceRefresh. */
  getDashboardMetrics: async (options?: { forceRefresh?: boolean }) => {
    if (!options?.forceRefresh) {
      const cached = readMetricsCache();
      if (cached) {
        void fetchFromApi(true);
        return cached;
      }
    }

    if (inFlight) return inFlight;

    inFlight = fetchFromApi().finally(() => {
      inFlight = null;
    });
    return inFlight;
  },

  /** Warm API + cache as soon as admin shell loads (reduces cold-start wait on dashboard). */
  prefetchDashboardMetrics: () => {
    if (readMetricsCache()) return;
    if (inFlight) return;
    inFlight = fetchFromApi().finally(() => {
      inFlight = null;
    });
  },
};
