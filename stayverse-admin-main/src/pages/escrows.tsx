import { useCallback, useEffect, useState } from "react";
import { Escrow, PaymentService } from "@/api/payment-service";
import { AdminEscrowStatus } from "@/types";
import EscrowsTable from "@/components/escrows/EscrowsTable";
import { ManualPaginationControl } from "@/components/ManualPagination";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

type EscrowStatus = "hold" | "partial" | "completed";
type PayoutType = "daily" | "whole";
type AdminStatus = AdminEscrowStatus;

export default function EscrowsPage() {
  const [escrows, setEscrows] = useState<Escrow[]>([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState<{
    pageIndex: number;
    pageSize: number;
  }>({ pageIndex: 0, pageSize: 10 });
  const [totalPages, setTotalPages] = useState<number>(1);
  const [totalItems, setTotalItems] = useState<number>(0);

  const [searchTerm, setSearchTerm] = useState<string>("");
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState<string>("");
  const [status, setStatus] = useState<"all" | EscrowStatus>("all");
  const [payoutType, setPayoutType] = useState<"all" | PayoutType>("all");
  const [adminEscrowStatus, setAdminEscrowStatus] = useState<
    "all" | AdminStatus
  >("all");

  const fetchEscrows = useCallback(() => {
    setLoading(true);
    PaymentService.getAllEscrows({
      page: pagination.pageIndex + 1,
      limit: pagination.pageSize,
      ...(status !== "all" && { status }),
      ...(payoutType !== "all" && { payoutType }),
      ...(adminEscrowStatus !== "all" && { adminEscrowStatus }),
      ...(debouncedSearchTerm ? { searchTerm: debouncedSearchTerm } : {}),
    })
      .then((res) => {
        setEscrows(res.data || []);
        setTotalPages(res.pagination?.totalPages || 1);
        setTotalItems(res.pagination?.totalItems || 0);
      })
      .finally(() => setLoading(false));
  }, [
    pagination.pageIndex,
    pagination.pageSize,
    status,
    payoutType,
    adminEscrowStatus,
    debouncedSearchTerm,
  ]);

  useEffect(() => {
    fetchEscrows();
  }, [fetchEscrows]);

  useEffect(() => {
    const t = setTimeout(() => setDebouncedSearchTerm(searchTerm), 300);
    return () => clearTimeout(t);
  }, [searchTerm]);

  useEffect(() => {
    setPagination((prev) => ({ ...prev, pageIndex: 0 }));
  }, [status, payoutType, adminEscrowStatus, searchTerm]);

  return (
    <section className="px-10 pb-12 pt-[30px] space-y-10 ">
      <div className="w-full flex items-center gap-5 flex-wrap">
        <h1 className="font-medium text-dark text-[32px]">Escrows</h1>
        <span className="ml-auto text-lg text-[#858585]">
          {totalItems} results
        </span>
      </div>

      <div className="w-full flex flex-wrap items-center gap-3">
        <div className="min-w-[240px]">
          <Input
            placeholder="Search by booking or user ID"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <Select value={status} onValueChange={(v) => setStatus(v as any)}>
          <SelectTrigger className="w-[180px] h-[41px] between text-[#363636] border border-[#DBDBDB] rounded-none bg-transparent">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="hold">Hold</SelectItem>
            <SelectItem value="partial">Partial</SelectItem>
            <SelectItem value="completed">Completed</SelectItem>
          </SelectContent>
        </Select>
        <Select
          value={payoutType}
          onValueChange={(v) => setPayoutType(v as any)}
        >
          <SelectTrigger className="w-[180px] h-[41px] between text-[#363636] border border-[#DBDBDB] rounded-none bg-transparent">
            <SelectValue placeholder="Payout Type" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Payout</SelectItem>
            <SelectItem value="daily">Daily</SelectItem>
            <SelectItem value="whole">Whole</SelectItem>
          </SelectContent>
        </Select>
        <Select
          value={adminEscrowStatus}
          onValueChange={(v) => setAdminEscrowStatus(v as any)}
        >
          <SelectTrigger className="w-[200px] h-[41px] between text-[#363636] border border-[#DBDBDB] rounded-none bg-transparent">
            <SelectValue placeholder="Admin Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Admin Status</SelectItem>
            <SelectItem value={AdminEscrowStatus.HELD}>Hold Payment</SelectItem>
            <SelectItem value={AdminEscrowStatus.RELEASED}>
              Release Payment
            </SelectItem>
            <SelectItem value={AdminEscrowStatus.AGENT_HOLD}>
              Pay Agent
            </SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="container !px-0 mx-auto">
        <EscrowsTable
          data={escrows}
          loading={loading}
          onRefetch={fetchEscrows}
        />
        <div className="mt-4">
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
