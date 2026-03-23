import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import useModalStore from "@/stores/modal.store";
import { Bath, BedDouble, CheckCircle, Users } from "lucide-react";
import { Apartment } from "@/types/apartment";
import { formatDate, formatCurrency } from "@/lib/format.utils";
import { ServiceStatus } from "@/types";
import { AgentService } from "@/api/agent-service";
import { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function ApartmentDetailsModal() {
  const { open, setOpen, metadata } = useModalStore().apartmentDetails;
  const apartment: Apartment | null = metadata || null;
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const updateApartmentStatus = (id: string, status: ServiceStatus) => {
    setLoading(true);
    AgentService.updateApartmentStatus(id, status)
      .then((result) => {
        if (result) {
          setOpen(false);
          navigate(0);
        }
      })
      .finally(() => {
        setLoading(false);
      });
  };

  if (!apartment) {
    return (
      <Dialog onOpenChange={setOpen} open={open} defaultOpen={open}>
        <DialogContent className="p-6 max-w-3xl">
          <DialogTitle className="sr-only">No Apartment Details</DialogTitle>
          <div className="text-center py-8">
            <p>Apartment information not available</p>
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-3xl p-5 gap-0 max-h-[90vh] overflow-y-auto">
        <DialogTitle className="sr-only">Apartment Details</DialogTitle>
        {/* Header */}
        <div className="p-8 pb-6 relative">
          <h2 className="text-2xl font-bold">
            {apartment.apartmentName} ({formatCurrency(apartment.pricePerDay)})
          </h2>
        </div>

        {/* Image Gallery */}
        <div className=" flex gap-3 overflow-x-auto pb-2">
          {apartment.apartmentImages.map((image, index) => (
            <div key={index} className="min-w-[240px] h-[150px] relative">
              <img
                src={image || "/placeholder.svg"}
                alt={`${apartment.apartmentName} image ${index + 1}`}
                className=" w-full h-full object-cover rounded-md"
              />
            </div>
          ))}
        </div>

        {/* Details Section */}
        <div className="px-8 pt-6 pb-6">
          <h3 className="font-semibold text-lg mb-3">Details</h3>
          <p className="text-sm text-gray-600 mb-4">{apartment.details}</p>

          <div className="flex gap-8">
            <div className="flex items-center gap-2">
              <BedDouble size={18} />
              <span className="text-sm">
                {apartment.numberOfBedrooms} Bedrooms
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Bath size={18} />
              <span className="text-sm">{0} Bathrooms</span>
            </div>

            <div className="flex items-center gap-2">
              <Users size={18} />
              <span className="text-sm">{apartment.maxGuests} Guests</span>
            </div>
          </div>
        </div>

        <div className="border-t border-gray-200"></div>

        {/* Features Section */}
        <div className="px-8 py-6">
          <h3 className="font-semibold text-lg mb-4">Features</h3>
          <div className="grid grid-cols-3 gap-y-4 gap-x-6">
            {apartment.amenities.map((item, index) => (
              <div className="flex items-center gap-2" key={index}>
                <CheckCircle size={18} className="text-primary" />
                <span className="text-sm">{item}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="border-t border-gray-200"></div>

        {/* House Rules Section */}
        <div className="px-8 py-6">
          <h3 className="font-semibold text-lg mb-4">House Rules</h3>
          <div className="space-y-2 text-sm text-gray-500">
            <p>Check-in: {formatDate(new Date(apartment.checkIn))}</p>
            <p>Check-out: {formatDate(new Date(apartment.checkOut))}</p>
          </div>
        </div>

        {/* Delete Button */}
        <div className="px-8 py-6">
          <div className="flex justify-end gap-2">
            {apartment.status === ServiceStatus.APPROVED ? (
              <Button
                className="bg-green-600 hover:bg-green-700 text-white w-[120px]"
                onClick={() =>
                  updateApartmentStatus(apartment._id, ServiceStatus.CANCELLED)
                }
                disabled={loading}
              >
                Deactivate
              </Button>
            ) : (
              <Button
                className="bg-green-600 hover:bg-green-700 text-white w-[120px]"
                onClick={() =>
                  updateApartmentStatus(apartment._id, ServiceStatus.APPROVED)
                }
                disabled={loading}
              >
                Approve
              </Button>
            )}
            {(apartment.status === ServiceStatus.PENDING ||
              (apartment.status as string) === "available") && (
              <Button
                className="bg-red-600 hover:bg-red-700 text-white w-[120px]"
                onClick={() =>
                  updateApartmentStatus(apartment._id, ServiceStatus.CANCELLED)
                }
                disabled={loading}
              >
                Decline
              </Button>
            )}
            <Button
              variant="outline"
              className="text-gray-600 hover:text-gray-900 hover:bg-gray-100 w-[120px]"
              onClick={() => setOpen(false)}
            >
              Close
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
