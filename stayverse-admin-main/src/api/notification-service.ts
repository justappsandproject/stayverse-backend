import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export type BroadcastAudience = "user" | "agent" | "all";

export interface BroadcastPayload {
  audience: BroadcastAudience;
  title: string;
  body: string;
  extras?: Record<string, string>;
}

export interface BroadcastResult {
  audience: BroadcastAudience;
  totalEligible: number;
  sentCount: number;
  failedCount: number;
}

export const NotificationService = {
  async sendCuratedBroadcast(payload: BroadcastPayload): Promise<BroadcastResult | null> {
    try {
      const response = await axiosInstance.post("/notification/broadcast", payload);
      if (response.status >= 200 && response.status < 300) {
        toast.success("Curated message sent successfully.");
        return response.data?.data as BroadcastResult;
      }
      toast.warning(response.data?.message || "Failed to send message");
      return null;
    } catch {
      toast.error("Failed to send curated message");
      return null;
    }
  },
};
