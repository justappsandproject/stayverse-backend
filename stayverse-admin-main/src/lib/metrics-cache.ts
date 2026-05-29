import type { DashboardMetrics } from "@/api/metrics-service";

const CACHE_KEY = "stayverse_admin_dashboard_metrics_v1";
const CACHE_TTL_MS = 5 * 60 * 1000;

type CachedPayload = {
  data: DashboardMetrics;
  savedAt: number;
};

export function readMetricsCache(): DashboardMetrics | null {
  try {
    const raw = sessionStorage.getItem(CACHE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as CachedPayload;
    if (Date.now() - parsed.savedAt > CACHE_TTL_MS) {
      sessionStorage.removeItem(CACHE_KEY);
      return null;
    }
    return parsed.data;
  } catch {
    return null;
  }
}

export function writeMetricsCache(data: DashboardMetrics) {
  try {
    const payload: CachedPayload = { data, savedAt: Date.now() };
    sessionStorage.setItem(CACHE_KEY, JSON.stringify(payload));
  } catch {
    // ignore quota / private mode
  }
}
