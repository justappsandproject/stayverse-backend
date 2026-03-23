import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { formatCurrency, formatMonthYear } from "@/lib/format.utils";
import useModalStore from "@/stores/modal.store";
import { Chef } from "@/types/chef";
import { Button } from "../ui/button";
import { ServiceStatus } from "@/types";
import { ChefService } from "@/api/chef-service";
import { useState } from "react";

export function ChefProfileModal() {
  const { open, setOpen, metadata } = useModalStore().chefProfileModal;
  const chefProfile: Chef | null = metadata?.chef || null;
  const [loading, setLoading] = useState(false);

  if (!chefProfile) {
    return (
      <Dialog open={open} onOpenChange={setOpen} defaultOpen={open}>
        <DialogContent className="sm:max-w-2xl p-8 max-h-[90vh] overflow-y-auto">
          <DialogTitle className="sr-only">No Chef Profile</DialogTitle>
          <div className="flex flex-col items-center justify-center h-full">
            <p className="text-center text-lg text-gray-500">
              No Data Available
            </p>
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  const handleChefStatusChange = (status: ServiceStatus) => {
    setLoading(true);
    ChefService.updateChefStatus(chefProfile._id, status)
      .then(() => {
        setOpen(false);
      })
      .finally(() => {
        setLoading(false);
      });
  };

  return (
    <Dialog open={open} onOpenChange={setOpen} defaultOpen={open}>
      <DialogContent className="sm:max-w-2xl p-0 gap-0 max-h-[90vh] overflow-y-auto">
        {/* Header with profile picture and name */}
        <DialogTitle className="sr-only">Chef Profile</DialogTitle>
        <div className="p-8 pb-6 border-b flex items-start gap-6">
          <div className="h-20 w-20 rounded-full overflow-hidden">
            <img
              src={chefProfile.profilePicture || "/placeholder.svg"}
              alt={chefProfile.fullName}
              width={80}
              height={80}
              className="h-full w-full object-cover"
            />
          </div>
          <div className="flex-1">
            <h2 className="text-xl font-bold">
              {chefProfile.fullName} (
              {formatCurrency(chefProfile.pricingPerHour)}/hr)
            </h2>
            <p className="text-sm text-gray-600 mt-2">{chefProfile.bio}</p>
          </div>
          {/* <Button variant="ghost" size="icon" className="h-8 w-8 rounded-full" onClick={onClose}>
                        <X className="h-4 w-4" />
                        <span className="sr-only">Close</span>
                    </Button> */}
        </div>

        {/* Stats section */}
        <div className="grid grid-cols-3 py-6 px-8 border-b">
          <div>
            <p className="text-sm text-gray-600 mb-1">Total Earnings</p>
            <p className="text-xl font-bold">
              {formatCurrency(chefProfile.totalEarnings)}
            </p>
          </div>
          <div>
            <p className="text-sm text-gray-600 mb-1">Orders</p>
            <p className="text-xl font-bold">{chefProfile.totalBookings}</p>
          </div>
          <div>
            <p className="text-sm text-gray-600 mb-1">No Of Withdrawal</p>
            <p className="text-xl font-bold">{chefProfile.withdrawalCount}</p>
          </div>
        </div>

        {/* About section */}
        <div className="px-8 py-6 border-b">
          <h3 className="font-semibold text-lg mb-3">About</h3>
          <p className="text-sm text-gray-600">{chefProfile.about}</p>
        </div>

        {/* Experience section */}
        <div className="px-8 py-6 border-b">
          <h3 className="font-semibold text-lg mb-4">Experience</h3>
          <div className="grid grid-cols-2 gap-6">
            {chefProfile.experiences.map((exp, index) => (
              <div key={index} className="space-y-1">
                <p className="font-medium">{exp.title}</p>
                <p className="text-sm text-gray-600">{exp.company}</p>
                <p className="text-sm text-gray-500">
                  {formatMonthYear(new Date(exp.startDate))} -{" "}
                  {exp.endDate
                    ? formatMonthYear(new Date(exp.endDate))
                    : "Present"}
                </p>
                <p className="text-sm text-gray-500">{exp.address}</p>
              </div>
            ))}
          </div>
        </div>

        {/* License & Certification section */}
        <div className="px-8 py-6">
          <h3 className="font-semibold text-lg mb-4">
            License & Certification
          </h3>
          {chefProfile.certifications.map((cert, index) => (
            <div key={index} className="space-y-1">
              <p className="font-medium">{cert.title}</p>
              <p className="text-sm text-gray-600">{cert.organization}</p>
              <p className="text-sm text-gray-500">Issued {cert.issuedDate}</p>
            </div>
          ))}
        </div>

        {/* Actions */}
        <div className="flex items-center justify-end px-8 py-6 gap-2">
          {chefProfile.status === ServiceStatus.CANCELLED ||
          chefProfile.status === ServiceStatus.PENDING ? (
            <Button
              className="bg-green-600 hover:bg-green-700 text-white w-[120px]"
              disabled={loading}
              onClick={() => handleChefStatusChange(ServiceStatus.APPROVED)}
            >
              Activate
            </Button>
          ) : (
            <Button
              className="bg-red-600 hover:bg-red-700 text-white w-[120px]"
              disabled={loading}
              onClick={() => handleChefStatusChange(ServiceStatus.CANCELLED)}
            >
              Deactivate
            </Button>
          )}
          <Button
            className="text-white w-[120px]"
            onClick={() => setOpen(false)}
          >
            Close
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
