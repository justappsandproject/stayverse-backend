import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import useModalStore from "@/stores/modal.store";
import { Car, CheckCircle, Hash, Users } from "lucide-react";
import { Ride } from "@/types/ride";
import { ServiceStatus } from "@/types";
import { AgentService } from "@/api/agent-service";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { formatCurrency } from "@/lib/format.utils";

export default function RideDetailsModal() {
  const { open, setOpen, metadata } = useModalStore().rideDetails;
  const ride: Ride | null = metadata || null;
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const updateRideStatus = (id: string, status: ServiceStatus) => {
    setLoading(true);
    AgentService.updateRideStatus(id, status)
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

  if (!ride) {
    return (
      <Dialog onOpenChange={setOpen} open={open} defaultOpen={open}>
        <DialogContent className="p-6 max-w-3xl">
          <DialogTitle className="sr-only">No Ride Details</DialogTitle>
          <div className="text-center py-8">
            <p>Ride information not available</p>
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-3xl p-5 gap-0 max-h-[90vh] overflow-y-auto">
        <DialogTitle className="sr-only">Ride Details</DialogTitle>
        {/* Header */}
        <div className="p-8 pb-6 relative">
          <h2 className="text-2xl font-bold">
            {ride.rideName} (
            {ride.pricePerDay
              ? `${formatCurrency(ride.pricePerDay)}/day`
              : `${formatCurrency(ride.pricePerHour || 0)}/hr`}
            )
          </h2>
          <p className="text-gray-600 mt-1">{ride.address}</p>
        </div>

        {/* Image Gallery */}
        <div className=" flex gap-3 overflow-x-auto pb-2">
          {ride.rideImages.map((image, index) => (
            <div key={index} className="min-w-[240px] h-[150px] relative">
              <img
                src={image || "/placeholder.svg"}
                alt={`${ride.rideName} image ${index + 1}`}
                className=" w-full h-full object-cover rounded-md"
              />
            </div>
          ))}
        </div>

        {/* Details Section*/}
        <div className="px-8 pt-6 pb-6">
          <h3 className="font-semibold text-lg mb-4">Details</h3>
          <p className="text-sm text-gray-600 mb-4">{ride.rideDescription}</p>

          <div className="grid grid-cols-2 gap-4 mt-4">
            <div className="flex items-center gap-2">
              <Car size={18} className="text-gray-500" />
              <div>
                <p className="text-xs text-gray-500">Vehicle Type</p>
                <p className="text-sm">{ride.rideType}</p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <Users size={18} className="text-gray-500" />
              <div>
                <p className="text-xs text-gray-500">Max Passengers</p>
                <p className="text-sm">{ride.maxPassengers} people</p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <Hash size={18} className="text-gray-500" />
              <div>
                <p className="text-xs text-gray-500">Plate Number</p>
                <p className="text-sm">{ride.plateNumber}</p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <div
                className="w-4 h-4 rounded-full"
                style={{ backgroundColor: ride.color }}
              />
              <div>
                <p className="text-xs text-gray-500">Color</p>
                <p className="text-sm capitalize">{ride.color}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Features Section */}
        <div className="px-8 pt-6 pb-6">
          <h3 className="font-semibold text-lg mb-4">Features</h3>
          <div className="grid grid-cols-3 gap-y-4 gap-x-6">
            {ride.features.map((item, index) => (
              <div className="flex items-center gap-2" key={index}>
                <CheckCircle size={18} className="text-primary" />
                <span className="text-sm">{item}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Rules Section */}
        <div className="px-8 pt-6 pb-6">
          <h3 className="font-semibold text-lg mb-4">Rules</h3>
          <div className="space-y-2 text-sm text-gray-600">
            <p className="whitespace-pre-line">{ride.rules}</p>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="px-8 py-4 border-t border-gray-200">
          <div className="flex justify-end gap-3">
            {ride.status === ServiceStatus.APPROVED ? (
              <Button
                variant="destructive"
                onClick={() =>
                  updateRideStatus(ride._id, ServiceStatus.CANCELLED)
                }
                disabled={loading}
              >
                Cancel Ride
              </Button>
            ) : (
              <Button
                className="bg-green-600 hover:bg-green-700 text-white w-[120px]"
                onClick={() =>
                  updateRideStatus(ride._id, ServiceStatus.APPROVED)
                }
                disabled={loading}
              >
                Approve Ride
              </Button>
            )}
            <Button
              variant="outline"
              onClick={() => setOpen(false)}
              disabled={loading}
            >
              Close
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
