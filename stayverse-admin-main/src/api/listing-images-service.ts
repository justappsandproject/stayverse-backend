import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export type ListingKind = "apartment" | "ride" | "chef";

const galleryField: Record<"apartment" | "ride", string> = {
  apartment: "apartmentImages",
  ride: "rideImages",
};

async function patchGallery(
  kind: "apartment" | "ride",
  id: string,
  keepImages: string[],
  newFiles: File[],
) {
  const formData = new FormData();
  formData.append("keepImages", JSON.stringify(keepImages));
  newFiles.forEach((file) => formData.append(galleryField[kind], file));

  const path = kind === "apartment" ? `/apartment/${id}/images` : `/ride/${id}/images`;
  const { data, status } = await axiosInstance.patch(path, formData, {
    headers: { "Content-Type": "multipart/form-data" },
  });

  if (status >= 200 && status < 300) {
    return data?.data ?? data;
  }
  throw new Error(data?.message || "Failed to update images");
}

export const ListingImagesService = {
  async updateApartmentImages(
    apartmentId: string,
    keepImages: string[],
    newFiles: File[],
  ) {
    try {
      const result = await patchGallery("apartment", apartmentId, keepImages, newFiles);
      toast.success("Apartment images updated.");
      return result;
    } catch (error: any) {
      toast.error(error?.response?.data?.message || error?.message || "Failed to update apartment images");
      return null;
    }
  },

  async updateRideImages(rideId: string, keepImages: string[], newFiles: File[]) {
    try {
      const result = await patchGallery("ride", rideId, keepImages, newFiles);
      toast.success("Ride images updated.");
      return result;
    } catch (error: any) {
      toast.error(error?.response?.data?.message || error?.message || "Failed to update ride images");
      return null;
    }
  },

  async updateChefImages(
    chefId: string,
    files: { profilePicture?: File; coverPhoto?: File },
  ) {
    try {
      const formData = new FormData();
      if (files.profilePicture) formData.append("profilePicture", files.profilePicture);
      if (files.coverPhoto) formData.append("coverPhoto", files.coverPhoto);

      const { data, status } = await axiosInstance.patch(`/chef/${chefId}/images`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      if (status >= 200 && status < 300) {
        toast.success("Chef photos updated.");
        return data?.data ?? data;
      }
      toast.warning(data?.message || "Failed to update chef photos");
      return null;
    } catch (error: any) {
      toast.error(error?.response?.data?.message || "Failed to update chef photos");
      return null;
    }
  },
};
