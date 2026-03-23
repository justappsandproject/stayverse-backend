import { ChefService } from "@/api/chef-service";
import { ManualPaginationControl } from "@/components/ManualPagination";
import StarRating from "@/components/StarRating";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import useModalStore from "@/stores/modal.store";
import { Chef } from "@/types/chef";
import { ChevronDown, RotateCw } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { cn } from "@/lib/utils";
import { ServiceStatus } from "@/types";

export default function ManageChefs() {
  const [chefs, setChefs] = useState<Chef[]>([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState<{
    pageIndex: number;
    pageSize: number;
  }>({
    pageIndex: 0,
    pageSize: 10,
  });
  const [totalPages, setTotalPages] = useState<number>(1);
  const [stats, setStats] = useState({
    totalChefs: 0,
    activeChefs: 0,
    inactiveChefs: 0,
  });

  const { setOpen: openChefProfileModal } = useModalStore().chefProfileModal;

  const fetchChefs = useCallback(() => {
    setLoading(true);
    ChefService.getAllChefs({
      page: pagination.pageIndex + 1,
      limit: pagination.pageSize,
    })
      .then((response) => {
        setChefs(response.data);
        setTotalPages(response.pagination.totalPages);
        setStats({
          totalChefs: response.pagination.totalItems,
          activeChefs: response.metadata?.totalActive || 0,
          inactiveChefs: response.metadata?.totalInactive || 0,
        });
      })
      .finally(() => {
        setLoading(false);
      });
  }, [pagination.pageIndex, pagination.pageSize]);

  useEffect(() => {
    fetchChefs();
  }, [fetchChefs]);

  return (
    <section className="px-10 py-10 lg:py-16 xl:py-20 space-y-10">
      <div className="w-fit grid grid-flow-col gap-8 mb-10 ">
        <div className="group w-[280px] h-[170px] relative  rounded-lg _bg-dark text-light bg-dark">
          <div className="absolute inset-0 bg-[#00000047]"></div>
          <div className="relative flex flex-col justify-center items-start gap-3 p-6 xl:p-8 z-10">
            <span className="text-[18px] font-medium ">Total Chefs</span>
            <span className="text-[64px] leading-10 font-bold ">
              {stats.totalChefs}
            </span>
          </div>
        </div>
        <div className="flex flex-col justify-end w-fit">
          <div className="gap-5 between">
            <span className="text-xs">Today</span>
            <span
              role="button"
              className="text-[#989898] text-xs cursor-pointer flex flex-col items-center hover:text-black/80"
              onClick={fetchChefs}
            >
              <RotateCw size={16} className={loading ? "animate-spin" : ""} />{" "}
              <span>Refresh</span>
            </span>
          </div>
          <div className="w-fit flex items-center gap-0 border border-[#DBDBDB] rounded-lg ">
            <div className="basis-5/12 px-10 py-6 flex flex-col justify-center items-center gap-3 p-6 ">
              <span className="text-[12px] text-dark ">Active</span>
              <span className="text-[64px] leading-10 font-bold  ">
                {stats.activeChefs}
              </span>
            </div>
            <Separator
              orientation="vertical"
              className="h-[80%] bg-[#DADADA]"
            />
            <div className="basis-7/12 px-10 py-6 flex flex-col justify-center items-center gap-3 p-6 ">
              <span className="text-[12px] text-dark ">Inactive</span>
              <span className="text-[64px] leading-10 font-bold  ">
                {stats.inactiveChefs}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div className="w-full">
        {/* List header */}
        <div className="flex items-center justify-between w-full mb-5">
          <h2 className="text-[32px] text-dark font-medium">All Chefs</h2>
          <div className="hidden _grid items-center grid-flow-col gap-5">
            <span className="px-5 py-3 flex gap-2 text-[#363636] border border-[#DBDBDB]">
              EDO STATE <ChevronDown />
            </span>
            <span className="px-5 py-3 flex gap-2 text-[#363636] border border-[#DBDBDB]">
              OREDO <ChevronDown />
            </span>
          </div>
        </div>

        {/* List body */}
        {/* List body */}
        <div className="w-full overflow-x-auto mb-10">
          {loading ? (
            <div className="space-y-4">
              {[...Array(5)].map((_, idx) => (
                <div
                  key={idx}
                  className="h-16 w-full bg-gray-100 animate-pulse rounded-md"
                />
              ))}
            </div>
          ) : chefs.length === 0 ? (
            <div className="flex justify-center items-center py-8">
              <p className="text-gray-500">No chefs found</p>
            </div>
          ) : (
            <div className="rounded-lg border border-gray-200 overflow-hidden">
              <Table>
                <TableHeader className="bg-gray-50/40">
                  <TableRow className="hover:bg-transparent border-b border-gray-100">
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Chef
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Email
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Phone Number
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Orders
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Status
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
                      Rating
                    </TableHead>
                    <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider text-right">
                      Action
                    </TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {chefs.map((chef) => (
                    <TableRow
                      key={chef._id}
                      className="cursor-pointer hover:bg-gray-50/30 transition-colors border-b border-gray-100 last:border-0"
                      onClick={() => openChefProfileModal(true, { chef })}
                    >
                      <TableCell className="py-3 px-5">
                        <div className="flex items-center gap-3">
                          <div className="flex-shrink-0">
                            {chef.profilePicture ? (
                              <img
                                src={chef.profilePicture}
                                alt={chef.fullName}
                                className="w-9 h-9 rounded-full object-cover border border-gray-100 shadow-sm"
                              />
                            ) : (
                              <div className="w-9 h-9 bg-gradient-to-br from-dark to-secondary rounded-full flex items-center justify-center text-white text-[13px] font-bold shadow-sm">
                                {chef.fullName.slice(0, 2).toUpperCase()}
                              </div>
                            )}
                          </div>
                          <div className="flex flex-col">
                            <span className="text-black font-semibold text-[14px] leading-tight">
                              {chef.fullName}
                            </span>
                            <span className="text-gray-400 text-[11px] font-normal uppercase tracking-tighter">
                              ID: {chef._id.slice(-6)}
                            </span>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell className="py-3 px-5 text-gray-600 text-[14px]">
                        {chef.agent?.email || chef.user?.email || "N/A"}
                      </TableCell>
                      <TableCell className="py-3 px-5 text-gray-600 text-[14px]">
                        {chef.agent?.phoneNumber ||
                          chef.user?.phoneNumber ||
                          "N/A"}
                      </TableCell>
                      <TableCell className="py-3 px-5 text-gray-600 font-medium text-[14px]">
                        {chef.totalBookings}
                      </TableCell>
                      <TableCell className="py-3 px-5">
                        <span
                          className={cn(
                            "capitalize px-2 py-1 rounded-full text-[12px] font-medium border",
                            chef.status === ServiceStatus.APPROVED
                              ? "bg-green-100 text-green-700 border-green-200"
                              : chef.status === ServiceStatus.PENDING
                                ? "bg-yellow-100 text-yellow-700 border-yellow-200"
                                : "bg-gray-100 text-gray-600 border-gray-200",
                          )}
                        >
                          {chef.status}
                        </span>
                      </TableCell>
                      <TableCell className="py-3 px-5">
                        <StarRating
                          rating={chef.averageRating || 0}
                          size={14}
                        />
                      </TableCell>
                      <TableCell className="py-3 px-5 text-right">
                        <Button
                          size="sm"
                          className="h-8 px-4 rounded-lg text-[13px] font-medium text-dark bg-primary-500 hover:bg-primary-600 transition-colors border-none shadow-none"
                          onClick={(e) => {
                            e.stopPropagation();
                            openChefProfileModal(true, { chef });
                          }}
                        >
                          View
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </div>

        {/* Pagination */}
        <ManualPaginationControl
          pageIndex={pagination.pageIndex}
          pageSize={pagination.pageSize}
          totalPages={totalPages}
          onChange={(pagination) => setPagination(pagination)}
        />
      </div>
    </section>
  );
}
