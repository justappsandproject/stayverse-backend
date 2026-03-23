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
import { RotateCcwIcon } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useState } from "react";
import { Escrow, PaymentService } from "@/api/payment-service";
import { AdminEscrowStatus } from "@/types";
import { useNavigate } from "react-router-dom";
import { Button } from "../ui/button";

interface EscrowsTableProps {
  data: Escrow[];
  loading: boolean;
  onRefetch?: () => void;
}

export default function EscrowsTable({
  data,
  loading,
  onRefetch,
}: EscrowsTableProps) {
  const [updatingId, setUpdatingId] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleUpdate = async (escrowId: string, status: AdminEscrowStatus) => {
    try {
      setUpdatingId(escrowId);
      await PaymentService.updateAdminEscrowStatus(escrowId, status);
      if (onRefetch) onRefetch();
    } finally {
      setUpdatingId(null);
    }
  };

  return (
    <div className="w-full max-w-7xl _mx-auto _p-4">
      <div className="rounded-lg border border-gray-200 overflow-hidden bg-white shadow-sm">
        <Table>
          <TableHeader className="bg-gray-50/50">
            <TableRow className="border-b border-gray-100">
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-nowrap">
                Payout
              </TableHead>
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-nowrap">
                Amounts
              </TableHead>
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-nowrap">
                Status
              </TableHead>
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-nowrap">
                Admin Status
              </TableHead>
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-nowrap">
                Created
              </TableHead>
              <TableHead className="py-3 px-6 text-gray-500 font-medium text-xs uppercase tracking-wider text-right text-nowrap">
                Actions
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={6} className="py-8 text-center text-nowrap">
                  <div className="w-full min-h-[60px] center">
                    <RotateCcwIcon className="animate-spin h-6 w-6 text-dark" />
                  </div>
                </TableCell>
              </TableRow>
            ) : data.length ? (
              data.map((escrow, index) => {
                const remaining = Math.max(
                  escrow.totalAmount - escrow.amountReleased,
                  0,
                );
                return (
                  <TableRow
                    key={escrow._id ?? index}
                    className={cn(
                      index % 2 === 0 ? "bg-white" : "bg-gray-50/30",
                      "border-b border-gray-100 last:border-0",
                    )}
                  >
                    <TableCell className="py-3 px-6 capitalize text-[13px] text-gray-600 font-medium text-nowrap">
                      {escrow.payoutType}
                    </TableCell>
                    <TableCell className="py-3 px-6 text-nowrap">
                      <div className="flex flex-col gap-0.5 min-w-[150px]">
                        <span className="text-[13px] text-gray-700 font-medium">
                          Total:{" "}
                          {isNaN(escrow.totalAmount)
                            ? "N/A"
                            : formatCurrency(escrow.totalAmount)}
                        </span>
                        <span className="text-[11px] text-gray-500">
                          Released:{" "}
                          {isNaN(escrow.amountReleased)
                            ? "N/A"
                            : formatCurrency(escrow.amountReleased)}
                        </span>
                        <span className="text-[11px] text-gray-500 font-bold">
                          Rem:{" "}
                          {isNaN(remaining) ? "N/A" : formatCurrency(remaining)}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell className="py-3 px-6 text-nowrap">
                      <span
                        className={cn(
                          "inline-flex justify-center px-2 py-0.5 rounded-full text-[11px] font-bold border capitalize",
                          escrow.status === "completed"
                            ? "bg-green-100 text-green-700 border-green-200"
                            : escrow.status === "partial"
                              ? "bg-yellow-100 text-yellow-700 border-yellow-200"
                              : "bg-blue-100 text-blue-700 border-blue-200",
                        )}
                      >
                        {escrow.status}
                      </span>
                    </TableCell>
                    <TableCell className="py-3 px-6 text-nowrap">
                      <Select
                        value={escrow.adminEscrowStatus}
                        onValueChange={(val: AdminEscrowStatus) =>
                          handleUpdate(escrow._id, val)
                        }
                        disabled={updatingId === escrow._id}
                      >
                        <SelectTrigger className="w-[150px] h-7 text-[12px] text-gray-700 border border-gray-200 rounded-lg bg-white shadow-sm hover:bg-gray-50 transition-colors">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent className="rounded-xl shadow-lg border-gray-100">
                          <SelectItem
                            value={AdminEscrowStatus.HELD}
                            className="text-[12px] py-2"
                          >
                            Hold Payment
                          </SelectItem>
                          <SelectItem
                            value={AdminEscrowStatus.RELEASED}
                            className="text-[12px] py-2"
                          >
                            Release Payment
                          </SelectItem>
                          <SelectItem
                            value={AdminEscrowStatus.AGENT_HOLD}
                            className="text-[12px] py-2"
                          >
                            Pay Agent
                          </SelectItem>
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell className="py-3 px-6 text-nowrap">
                      <div className="min-w-[100px]">
                        <p className="font-medium text-gray-900 text-[13px]">
                          {new Date(escrow.createdAt).toLocaleDateString(
                            "en-US",
                            { month: "short", day: "numeric", year: "numeric" },
                          )}
                        </p>
                        <p className="text-[11px] text-gray-400 font-medium">
                          Day {escrow.lastReleasedDay}
                        </p>
                      </div>
                    </TableCell>
                    <TableCell className="py-3 px-6 text-right text-nowrap">
                      <Button
                        size="sm"
                        variant="outline"
                        className="h-7 px-3 text-[11px] font-bold border-gray-200 hover:bg-gray-50 transition-colors"
                        onClick={() =>
                          navigate(`/bookings/${escrow.bookingId}`)
                        }
                      >
                        View
                      </Button>
                    </TableCell>
                  </TableRow>
                );
              })
            ) : (
              <TableRow>
                <TableCell colSpan={6} className="py-8">
                  <div className="w-full text-center text-gray-500">
                    No results.
                  </div>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
