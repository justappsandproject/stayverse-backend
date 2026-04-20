import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export type BroadcastAudience = "user" | "agent" | "all";
export type ImagePosition = "before" | "after";
export type SendMode = "now" | "scheduled";

export interface BroadcastPayload {
  audience: BroadcastAudience;
  title: string;
  body: string;
  imageUrl?: string;
  imagePosition?: ImagePosition;
  sendMode?: SendMode;
  scheduledAt?: string;
  extras?: Record<string, string>;
}

export interface BroadcastResult {
  audience: BroadcastAudience;
  totalEligible: number;
  sentCount: number;
  failedCount: number;
  emailSentCount?: number;
  emailFailedCount?: number;
  scheduled?: boolean;
  scheduledAt?: string;
  status?: "pending" | "sent";
}

export interface CuratedAdminMessage {
  _id: string;
  audience: BroadcastAudience;
  title: string;
  body: string;
  imageUrl?: string;
  imagePosition?: ImagePosition;
  sendMode?: SendMode;
  scheduledAt?: string;
  status?: "pending" | "sent";
  createdAt?: string;
  metrics?: {
    viewedCount?: number;
    readCount?: number;
    likeCount?: number;
    dislikeCount?: number;
  };
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

  async listCuratedMessagesForAdmin(page = 1, limit = 20): Promise<CuratedAdminMessage[]> {
    try {
      const response = await axiosInstance.get("/notification/curated/admin", {
        params: { page, limit },
      });
      const payload = response.data?.data;
      const items = payload?.data;
      if (Array.isArray(items)) return items as CuratedAdminMessage[];
      return [];
    } catch {
      toast.error("Failed to load curated messages");
      return [];
    }
  },
};
