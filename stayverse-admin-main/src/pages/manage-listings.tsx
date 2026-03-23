import { ApartmentService } from "@/api/apartment-service";
import { RideService } from "@/api/ride-service";
import { ManualPaginationControl } from "@/components/ManualPagination";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { cn } from "@/lib/utils";
import { ServiceStatus } from "@/types";
import { Apartment } from "@/types/apartment";
import { Ride } from "@/types/ride";
import {
  RotateCw,
  Home,
  Car,
  CheckCircle2,
  Clock,
  XCircle,
} from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { formatCurrency } from "@/lib/format.utils";
import useModalStore from "@/stores/modal.store";

type ListingTab = "apartments" | "rides";

export default function ManageListings() {
  const [activeTab, setActiveTab] = useState<ListingTab>("apartments");
  const [status, setStatus] = useState<string>("all");
  const [items, setItems] = useState<(Apartment | Ride)[]>([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState({
    pageIndex: 0,
    pageSize: 10,
  });
  const [totalPages, setTotalPages] = useState(1);
  const { setOpen: setApartmentModal } = useModalStore().apartmentDetails;
  const { setOpen: setRideModal } = useModalStore().rideDetails;

  const fetchItems = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        page: pagination.pageIndex + 1,
        limit: pagination.pageSize,
        ...(status !== "all" && { status: status as ServiceStatus }),
      };

      let response: any;
      let data: (Apartment | Ride)[] = [];
      if (activeTab === "apartments") {
        response = await ApartmentService.getAllApartments(params);
        data = response?.apartments || [];
      } else {
        response = await RideService.getAllRides(params);
        data = response?.rides || [];
      }

      // Fallback client-side filtering if backend ignores it
      if (status !== "all") {
        data = data.filter((item) => item.status === status);
      }

      setItems(data);
      setTotalPages(response?.pagination?.totalPages || 1);
    } catch (error) {
      console.error("Failed to fetch listings:", error);
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, [activeTab, pagination.pageIndex, pagination.pageSize, status]);

  useEffect(() => {
    fetchItems();
  }, [fetchItems]);

  const handleStatusUpdate = async (id: string, newStatus: string) => {
    if (activeTab === "apartments") {
      await ApartmentService.updateApartmentStatus(id, newStatus);
    } else {
      await RideService.updateRideStatus(id, newStatus);
    }
    fetchItems();
  };

  const getStatusColor = (status: string) => {
    switch (status?.toLowerCase()) {
      case ServiceStatus.APPROVED:
        return "bg-green-100 text-green-700 border-green-200";
      case ServiceStatus.PENDING:
        return "bg-yellow-100 text-yellow-700 border-yellow-200";
      case ServiceStatus.CANCELLED:
      case "rejected":
        return "bg-red-100 text-red-700 border-red-200";
      default:
        return "bg-gray-100 text-gray-700 border-gray-200";
    }
  };

  return (
    <section className="px-10 py-10 space-y-8">
      <div className="flex flex-col gap-6">
        <h2 className="text-2xl font-bold text-dark">Manage Listings</h2>

        {/* Tabs */}
        <div className="flex items-center gap-4 bg-gray-100 p-1 rounded-xl w-fit border border-gray-200">
          <button
            onClick={() => {
              setActiveTab("apartments");
              setPagination({ ...pagination, pageIndex: 0 });
            }}
            className={cn(
              "flex items-center gap-2 px-6 py-2.5 rounded-lg text-[14px] font-semibold transition-all",
              activeTab === "apartments"
                ? "bg-white text-dark shadow-sm"
                : "text-gray-500 hover:text-dark",
            )}
          >
            <Home size={18} />
            Apartments
          </button>
          <button
            onClick={() => {
              setActiveTab("rides");
              setPagination({ ...pagination, pageIndex: 0 });
            }}
            className={cn(
              "flex items-center gap-2 px-6 py-2.5 rounded-lg text-[14px] font-semibold transition-all",
              activeTab === "rides"
                ? "bg-white text-dark shadow-sm"
                : "text-gray-500 hover:text-dark",
            )}
          >
            <Car size={18} />
            Rides
          </button>
        </div>

        {/* Filters */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            {[
              { label: "All", value: "all", icon: null },
              { label: "Pending", value: "pending", icon: Clock },
              { label: "Approved", value: "approved", icon: CheckCircle2 },
              { label: "Cancelled", value: "cancelled", icon: XCircle },
            ].map((f) => (
              <button
                key={f.value}
                onClick={() => {
                  setStatus(f.value);
                  setPagination({ ...pagination, pageIndex: 0 });
                }}
                className={cn(
                  "flex items-center gap-2 px-4 py-2 rounded-xl text-[13px] font-medium transition-all border",
                  status === f.value
                    ? "bg-primary-500 text-dark border-primary-600 shadow-sm"
                    : "bg-white text-gray-500 border-gray-200 hover:border-gray-300",
                )}
              >
                {f.icon && <f.icon size={14} />}
                {f.label}
              </button>
            ))}
          </div>

          <button
            onClick={fetchItems}
            className="flex items-center gap-2 text-gray-400 hover:text-dark transition-colors text-sm font-medium"
          >
            <RotateCw size={16} className={loading ? "animate-spin" : ""} />
            Refresh
          </button>
        </div>
      </div>

      <div className="w-full">
        <div className="rounded-xl border border-gray-200 overflow-hidden bg-white shadow-sm">
          <Table>
            <TableHeader className="bg-gray-50/40">
              <TableRow className="hover:bg-transparent border-b border-gray-100">
                <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                  Listing Details
                </TableHead>
                <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                  Host / Agent
                </TableHead>
                <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                  Price
                </TableHead>
                <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                  Status
                </TableHead>
                <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider text-right">
                  Actions
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                Array(5)
                  .fill(0)
                  .map((_, i) => (
                    <TableRow key={i}>
                      {[...Array(5)].map((_, j) => (
                        <TableCell key={j} className="py-4 px-5">
                          <div className="h-6 w-full bg-gray-100 animate-pulse rounded" />
                        </TableCell>
                      ))}
                    </TableRow>
                  ))
              ) : items.length === 0 ? (
                <TableRow>
                  <TableCell
                    colSpan={5}
                    className="py-20 text-center text-gray-500"
                  >
                    No {activeTab} found for this filter.
                  </TableCell>
                </TableRow>
              ) : (
                items.map((item) => (
                  <TableRow
                    key={item._id}
                    className="hover:bg-gray-50/30 transition-colors border-b border-gray-100 last:border-0"
                  >
                    <TableCell className="py-3 px-5">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-10 rounded-lg overflow-hidden border border-gray-100 bg-gray-50">
                          {activeTab === "apartments" ? (
                            <img
                              src={(item as Apartment).apartmentImages?.[0]}
                              className="w-full h-full object-cover"
                              alt="listing"
                              onError={(e) => (e.currentTarget.src = "")}
                            />
                          ) : (
                            <img
                              src={(item as Ride).rideImages?.[0]}
                              className="w-full h-full object-cover"
                              alt="listing"
                              onError={(e) => (e.currentTarget.src = "")}
                            />
                          )}
                        </div>
                        <div className="flex flex-col">
                          <span className="text-black font-semibold text-[14px]">
                            {activeTab === "apartments"
                              ? (item as Apartment).apartmentName
                              : (item as Ride).rideName}
                          </span>
                          <span className="text-gray-400 text-[11px] uppercase tracking-tighter">
                            ID: {item._id.slice(-6)}
                          </span>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell className="py-3 px-5">
                      <div className="flex flex-col">
                        <span className="text-dark font-medium text-[14px]">
                          {activeTab === "apartments"
                            ? `${(item as Apartment).agent?.user?.firstname || ""} ${(item as Apartment).agent?.user?.lastname || ""}`
                            : `${(item as Ride).agent?.user?.firstname || ""} ${(item as Ride).agent?.user?.lastname || ""}`}
                        </span>
                        <span className="text-gray-400 text-[12px]">
                          {activeTab === "apartments"
                            ? (item as Apartment).agent?.user?.email
                            : (item as Ride).agent?.user?.email}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell className="py-3 px-5 text-gray-700 font-bold text-[14px]">
                      {activeTab === "apartments"
                        ? formatCurrency((item as Apartment).pricePerDay || 0)
                        : (item as Ride).pricePerDay
                          ? `${formatCurrency((item as Ride).pricePerDay!)}/day`
                          : `${formatCurrency((item as Ride).pricePerHour || 0)}/hr`}
                    </TableCell>
                    <TableCell className="py-3 px-5">
                      <span
                        className={cn(
                          "capitalize px-2 py-0.5 rounded-full text-[11px] font-bold border",
                          getStatusColor(item.status),
                        )}
                      >
                        {item.status}
                      </span>
                    </TableCell>
                    <TableCell className="py-3 px-5 text-right">
                      <div className="flex items-center justify-end gap-2">
                        {item.status === ServiceStatus.PENDING && (
                          <Button
                            size="sm"
                            className="bg-green-600 hover:bg-green-700 text-white h-7 px-3 text-[11px] font-bold"
                            onClick={() =>
                              handleStatusUpdate(
                                item._id,
                                ServiceStatus.APPROVED,
                              )
                            }
                          >
                            Approve
                          </Button>
                        )}
                        <Button
                          size="sm"
                          variant="outline"
                          className="h-7 px-3 text-[11px] font-bold border-gray-200"
                          onClick={() => {
                            if (activeTab === "apartments") {
                              setApartmentModal(true, item);
                            } else {
                              setRideModal(true, item);
                            }
                          }}
                        >
                          View
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>

        <div className="mt-6">
          <ManualPaginationControl
            pageIndex={pagination.pageIndex}
            pageSize={pagination.pageSize}
            totalPages={totalPages}
            onChange={(p) => setPagination(p)}
          />
        </div>
      </div>
    </section>
  );
}
