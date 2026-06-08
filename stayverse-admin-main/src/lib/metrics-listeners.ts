import type { DashboardMetrics } from '@/api/metrics-service';

type MetricsListener = (metrics: DashboardMetrics) => void;

const listeners = new Set<MetricsListener>();

export function subscribeMetrics(listener: MetricsListener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function notifyMetricsListeners(metrics: DashboardMetrics) {
  listeners.forEach((listener) => listener(metrics));
}
