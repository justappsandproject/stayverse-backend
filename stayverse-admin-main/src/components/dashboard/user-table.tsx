import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { User } from "@/types/user";
import useModalStore from "@/stores/modal.store";
import { cn } from "@/lib/utils";
import { format } from "date-fns";

interface UserTableProps {
  users: User[];
  loading?: boolean;
  actionLoadingUserId?: string | null;
  onApproveUser?: (userId: string) => void;
  onDeclineUser?: (userId: string) => void;
}

const StatusBadge = ({
  status,
  variant = "default",
}: {
  status: string;
  variant?: "success" | "warning" | "error" | "default";
}) => {
  const variants = {
    success: "bg-green-100 text-green-700 border-green-200",
    warning: "bg-yellow-100 text-yellow-700 border-yellow-200",
    error: "bg-red-100 text-red-700 border-red-200",
    default: "bg-gray-100 text-gray-700 border-gray-200",
  };

  return (
    <span
      className={cn(
        "px-2 py-1 rounded-full text-xs font-medium border",
        variants[variant],
      )}
    >
      {status}
    </span>
  );
};

export function UserTable({
  users,
  loading,
  actionLoadingUserId,
  onApproveUser,
  onDeclineUser,
}: UserTableProps) {
  const { setOpen: openUserProfileModal } = useModalStore().userProfileModal;

  if (loading) {
    return (
      <div className="w-full border rounded-lg overflow-hidden animate-pulse">
        <div className="h-12 bg-gray-100 border-b" />
        {[...Array(5)].map((_, i) => (
          <div key={i} className="h-16 bg-white border-b last:border-0" />
        ))}
      </div>
    );
  }

  return (
    <div className="w-full border rounded-lg overflow-hidden bg-white">
      <Table>
        <TableHeader className="bg-gray-50/40">
          <TableRow className="hover:bg-transparent">
            <TableHead className="w-[280px] py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              User
            </TableHead>
            <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              Email
            </TableHead>
            <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              Phone
            </TableHead>
            <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              Email Status
            </TableHead>
            <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              KYC Status
            </TableHead>
            <TableHead className="py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              Joined Date
            </TableHead>
            <TableHead className="text-right py-3 px-5 text-gray-500 font-medium text-xs uppercase tracking-wider">
              Action
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {users.map((user) => (
            <TableRow
              key={user._id}
              className="cursor-pointer hover:bg-gray-50/30 transition-colors border-b border-gray-100 last:border-0"
              onClick={() => openUserProfileModal(true, { user })}
            >
              <TableCell className="py-3 px-5">
                <div className="flex items-center gap-3">
                  {user?.profilePicture ? (
                    <img
                      src={user?.profilePicture}
                      alt={user.firstname}
                      className="w-9 h-9 object-cover rounded-full border border-gray-100 shadow-sm"
                    />
                  ) : (
                    <div className="w-9 h-9 bg-gradient-to-br from-dark to-secondary rounded-full flex items-center justify-center text-white text-[13px] font-bold shadow-sm">
                      {user.firstname.slice(0, 2).toUpperCase()}
                    </div>
                  )}
                  <div className="flex flex-col">
                    <span className="text-black font-semibold text-[14px] leading-tight">
                      {user.firstname} {user.lastname}
                    </span>
                    <span className="text-gray-400 text-[11px] font-normal uppercase tracking-tighter">
                      ID: {user._id.slice(-6)}
                    </span>
                  </div>
                </div>
              </TableCell>
              <TableCell className="text-gray-600 text-[14px] py-3 px-5">
                {user.email}
              </TableCell>
              <TableCell className="text-gray-600 text-[14px] py-3 px-5">
                {user.phoneNumber}
              </TableCell>
              <TableCell className="py-3 px-5">
                <StatusBadge
                  status={user.isEmailVerified ? "Verified" : "Unverified"}
                  variant={user.isEmailVerified ? "success" : "warning"}
                />
              </TableCell>
              <TableCell className="py-3 px-5">
                <StatusBadge
                  status={user.kycStatus || "Pending"}
                  variant={
                    user.kycStatus === "approved" || user.kycStatus === "verified"
                      ? "success"
                      : user.kycStatus === "pending"
                        ? "warning"
                        : user.kycStatus === "rejected" || user.kycStatus === "declined"
                          ? "error"
                          : "default"
                  }
                />
              </TableCell>
              <TableCell className="text-gray-500 text-[13px] py-3 px-5">
                {user.createdAt
                  ? format(new Date(user.createdAt), "MMM dd, yyyy")
                  : "N/A"}
              </TableCell>
              <TableCell className="text-right py-3 px-5">
                <div className="flex items-center justify-end gap-2">
                  <button
                    className="px-3 py-1.5 rounded-lg text-[12px] font-medium text-white bg-green-600 hover:bg-green-700 transition-colors disabled:opacity-60"
                    disabled={actionLoadingUserId === user._id}
                    onClick={(e) => {
                      e.stopPropagation();
                      onApproveUser?.(user._id);
                    }}
                  >
                    Approve
                  </button>
                  <button
                    className="px-3 py-1.5 rounded-lg text-[12px] font-medium text-white bg-red-600 hover:bg-red-700 transition-colors disabled:opacity-60"
                    disabled={actionLoadingUserId === user._id}
                    onClick={(e) => {
                      e.stopPropagation();
                      onDeclineUser?.(user._id);
                    }}
                  >
                    Decline
                  </button>
                  <button
                    className="px-4 py-1.5 rounded-lg text-[13px] font-medium text-dark bg-primary-500 hover:bg-primary-600 transition-colors"
                    onClick={(e) => {
                      e.stopPropagation();
                      openUserProfileModal(true, { user });
                    }}
                  >
                    View
                  </button>
                </div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
