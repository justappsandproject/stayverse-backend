import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export interface Testimonial {
  _id: string;
  name: string;
  role: string;
  city: string;
  rating: number;
  quote: string;
  isActive: boolean;
  sortOrder: number;
  createdAt?: string;
  updatedAt?: string;
}

export interface TestimonialPayload {
  name: string;
  role: string;
  city: string;
  rating: number;
  quote: string;
  isActive?: boolean;
  sortOrder?: number;
}

function parseError(error: unknown, fallback: string) {
  const err = error as { response?: { data?: { message?: string | string[] } } };
  const message = err?.response?.data?.message;
  if (Array.isArray(message)) return message.join(", ");
  if (typeof message === "string" && message.trim()) return message;
  return fallback;
}

export const TestimonialService = {
  async list(): Promise<Testimonial[]> {
    try {
      const response = await axiosInstance.get("/testimonials");
      const items = response.data?.data;
      return Array.isArray(items) ? (items as Testimonial[]) : [];
    } catch (error) {
      toast.error(parseError(error, "Failed to load testimonials"));
      return [];
    }
  },

  async create(payload: TestimonialPayload): Promise<Testimonial | null> {
    try {
      const response = await axiosInstance.post("/testimonials", payload);
      if (response.status >= 200 && response.status < 300) {
        toast.success("Testimonial created.");
        return response.data?.data as Testimonial;
      }
      toast.warning(parseError(response, "Failed to create testimonial"));
      return null;
    } catch (error) {
      toast.error(parseError(error, "Failed to create testimonial"));
      return null;
    }
  },

  async update(id: string, payload: Partial<TestimonialPayload>): Promise<Testimonial | null> {
    try {
      const response = await axiosInstance.patch(`/testimonials/${id}`, payload);
      if (response.status >= 200 && response.status < 300) {
        toast.success("Testimonial updated.");
        return response.data?.data as Testimonial;
      }
      toast.warning(parseError(response, "Failed to update testimonial"));
      return null;
    } catch (error) {
      toast.error(parseError(error, "Failed to update testimonial"));
      return null;
    }
  },

  async remove(id: string): Promise<boolean> {
    try {
      const response = await axiosInstance.delete(`/testimonials/${id}`);
      if (response.status >= 200 && response.status < 300) {
        toast.success("Testimonial deleted.");
        return true;
      }
      toast.warning(parseError(response, "Failed to delete testimonial"));
      return false;
    } catch (error) {
      toast.error(parseError(error, "Failed to delete testimonial"));
      return false;
    }
  },
};
