import { AgentService } from "@/api/agent-service";

import { ManualPaginationControl } from "@/components/ManualPagination";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
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
import { formatCurrency } from "@/lib/format.utils";
import { cn } from "@/lib/utils";
import { ServiceType } from "@/types";
import { Agent } from "@/types/agent";
import { RotateCw } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function ManageHosts() {
  const navigate = useNavigate();
  const [searchTerm] = useState("");
  const [status, setStatus] = useState("all");
  const [tab, setTab] = useState<"apartment-host" | "car-host">(
    "apartment-host"
  );

  const [totalActive, setTotalActive] = useState(0);
  const [totalInactive, setTotalInactive] = useState(0);
  const [agents, setAgents] = useState<Agent[]>([]);
  const [loading, setLoading] = useState(false);
  const [actionLoadingUserId, setActionLoadingUserId] = useState<string | null>(null);
  const [pagination, setPagination] = useState<{
    pageIndex: number;
    pageSize: number;
  }>({
    pageIndex: 0,
    pageSize: 10,
  });
  const [totalPages, setTotalPages] = useState<number>(1);

  const fetchAgents = useCallback(() => {
    setLoading(true);
    AgentService.getAllAgents({
      page: pagination.pageIndex + 1,
      limit: pagination.pageSize,
      searchTerm,
      serviceType:
        tab === "apartment-host" ? ServiceType.APARTMENT : ServiceType.RIDE,
      ...(status !== "all" && {
        isEmailVerified: status === "verified" ? "true" : "false",
      }),
    })
      .then((response) => {
        setAgents(response.data);
        setTotalPages(response.pagination.totalPages);
        if (response.metadata) {
          setTotalActive(response.metadata.totalActive);
          setTotalInactive(response.metadata.totalInactive);
        }
      })
      .finally(() => {
        setLoading(false);
      });
  }, [pagination.pageIndex, pagination.pageSize, searchTerm, status, tab]);

  useEffect(() => {
    fetchAgents();
  }, [fetchAgents]);

  const handleApproveAgent = async (userId: string) => {
    setActionLoadingUserId(userId);
    try {
      await AgentService.updateAgentKycStatus(userId, "verified");
      fetchAgents();
    } finally {
      setActionLoadingUserId(null);
    }
  };

  const handleDeclineAgent = async (userId: string) => {
    setActionLoadingUserId(userId);
    try {
      await AgentService.updateAgentKycStatus(userId, "declined");
      fetchAgents();
    } finally {
      setActionLoadingUserId(null);
    }
  };

  return (
    <section className="w-full px-10 py-10 lg:py-16 xl:py-20">
      <div className="start gap-7 mb-[18px]">
        <button
          onClick={() => setTab("apartment-host")}
          className={cn(
            "px-6 py-[10px] rounded-[8px] cursor-pointer",
            tab === "apartment-host"
              ? "bg-primary-500 text-white"
              : "text-dark border border-[#8A8A8A]"
          )}
        >
          Apartments
        </button>
        <button
          onClick={() => setTab("car-host")}
          className={cn(
            "px-6 py-[10px] rounded-[8px] cursor-pointer",
            tab === "car-host"
              ? "bg-primary-500 text-white"
              : "text-dark border border-[#8A8A8A]"
          )}
        >
          Rides
        </button>
      </div>
      <div className="w-fit grid grid-flow-col gap-8 mb-10 ">
        <div className="group w-[280px] h-[170px] relative rounded-lg overflow-hidden text-light bg-[url(/images/card-pattern-background.png)]">
          <div className="absolute inset-0 bg-[#00000047]"></div>
          <div className="relative flex flex-col justify-center items-start gap-3 p-6 xl:p-8 z-10">
            <span className="text-[18px] font-medium ">Total Hosts</span>
            <span className="text-[64px] leading-10 font-bold ">
              {totalActive + totalInactive > 900
                ? `${Math.ceil((totalActive + totalInactive) / 1000)}k`
                : totalActive + totalInactive}
            </span>
          </div>
        </div>
        <div className="flex flex-col justify-end w-fit">
          <div className="gap-5 between">
            <span className="text-xs">Today</span>
            <span
              role="button"
              className="text-[#989898] text-xs cursor-pointer flex flex-col items-center hover:text-black/80"
              onClick={fetchAgents}
            >
              <RotateCw size={16} className={loading ? "animate-spin" : ""} />{" "}
              <span>Refresh</span>
            </span>
          </div>
          <div className="w-fit flex items-center gap-0 border border-[#DBDBDB] rounded-lg ">
            <div className="basis-5/12 px-10 py-6 flex flex-col justify-center items-center gap-3 p-6 ">
              <span className="text-[12px] text-dark ">Active</span>
              <span className="text-[64px] leading-10 font-bold  ">
                {totalActive > 900
                  ? `${Math.ceil(totalActive / 1000)}k`
                  : totalActive}
              </span>
            </div>
            <Separator
              orientation="vertical"
              className="h-[80%] bg-[#DADADA]"
            />
            <div className="basis-7/12 px-10 py-6 flex flex-col justify-center items-center gap-3 p-6 ">
              <span className="text-[12px] text-dark ">Inactive</span>
              <span className="text-[64px] leading-10 font-bold  ">
                {totalInactive > 900
                  ? `${Math.ceil(totalInactive / 1000)}k`
                  : totalInactive}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div className="w-full space-y-7">
        <div className="w-full flex items-center justify-between">
          <span className="text-lg text-[#858585]">
            {agents.length} results
          </span>
          <div className="grid grid-flow-col items-center gap-5">
            <span className="text-lg text-[#858585]">Sort by</span>
            <Select onValueChange={setStatus} value={status}>
              <SelectTrigger className="w-[160px] h-[41px] between _px-5 _py-3 flex gap-2 text-[#363636] border border-[#DBDBDB] rounded-none bg-transparent text-base ">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All</SelectItem>
                <SelectItem value="verified">Verified</SelectItem>
                <SelectItem value="not-verified">Not verified</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        <div className="w-full overflow-x-auto">
          {loading ? (
            <div className="space-y-4">
              {[...Array(5)].map((_, idx) => (
                <div
                  key={idx}
                  className="h-16 w-full bg-gray-100 animate-pulse rounded-md"
                />
              ))}
            </div>
          ) : agents.length === 0 ? (
            <div className="flex justify-center items-center py-8">
              <p className="text-gray-500">No agents found</p>
            </div>
          ) : (
            <div className="rounded-lg border border-gray-200 overflow-hidden">
              <Table>
                <TableHeader className="bg-gray-50">
                  <TableRow className="border-b border-gray-200">
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      Host
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      Phone Number
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      Orders
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      Total Earned
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      Joined
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium">
                      KYC Status
                    </TableHead>
                    <TableHead className="py-4 px-6 text-gray-600 font-medium text-right">
                      Action
                    </TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {agents.map((agent, index) => (
                    <TableRow
                      key={agent._id}
                      className={`hover:bg-gray-50 ${
                        index % 2 === 0 ? "bg-white" : "bg-gray-50"
                      }`}
                    >
                      <TableCell className="py-4 px-6">
                        <div className="flex items-center gap-4">
                          <div className="w-10 h-10 aspect-square rounded-full bg-gradient-to-b from-dark to-secondary flex items-center justify-center overflow-hidden">
                            {agent.user?.profilePicture ? (
                              <img
                                src={agent.user.profilePicture}
                                alt="profile"
                                className="w-full h-full object-cover"
                              />
                            ) : (
                              <span className="text-white text-xs font-bold">
                                {agent.user?.firstname?.slice(0, 2) || "HO"}
                              </span>
                            )}
                          </div>
                          <div className="flex flex-col">
                            <span className="font-bold text-gray-900">
                              {agent.user?.firstname} {agent.user?.lastname}
                            </span>
                            <span className="text-sm text-gray-500">
                              {agent.user?.email}
                            </span>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell className="py-4 px-6 font-medium">
                        {agent.user?.phoneNumber || "N/A"}
                      </TableCell>
                      <TableCell className="py-4 px-6 font-medium">
                        {agent.totalBookings} Orders
                      </TableCell>
                      <TableCell className="py-4 px-6">
                        <span className="font-bold">
                          {formatCurrency(agent.totalEarnings)}
                        </span>
                      </TableCell>
                      <TableCell className="py-4 px-6 text-gray-500">
                        {new Date(agent.createdAt).toLocaleDateString("en-NG", {
                          day: "numeric",
                          month: "short",
                          year: "numeric",
                        })}
                      </TableCell>
                      <TableCell className="py-4 px-6">
                        <span
                          className={cn(
                            "capitalize font-medium px-2 py-1 rounded-full text-xs",
                            agent.user?.kycStatus === "approved" ||
                              agent.user?.kycStatus === "verified"
                              ? "bg-green-100 text-green-700"
                              : agent.user?.kycStatus === "pending"
                              ? "bg-yellow-100 text-yellow-700"
                              : agent.user?.kycStatus === "declined" ||
                                  agent.user?.kycStatus === "rejected"
                                ? "bg-red-100 text-red-700"
                              : "bg-gray-100 text-gray-700"
                          )}
                        >
                          {agent.user?.kycStatus || "N/A"}
                        </span>
                      </TableCell>
                      <TableCell className="py-4 px-6 text-right">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            size="sm"
                            className="bg-green-600 hover:bg-green-700 text-white"
                            disabled={actionLoadingUserId === agent.userId}
                            onClick={() => handleApproveAgent(agent.userId)}
                          >
                            Approve
                          </Button>
                          <Button
                            size="sm"
                            className="bg-red-600 hover:bg-red-700 text-white"
                            disabled={actionLoadingUserId === agent.userId}
                            onClick={() => handleDeclineAgent(agent.userId)}
                          >
                            Decline
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() =>
                              navigate(`/hosts/${agent._id}/${agent.serviceType}`)
                            }
                          >
                            View
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </div>
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
