import { UserService } from "@/api/user-service";
import MetricCard from "@/components/dashboard/metrics-card";
import { UserTable } from "@/components/dashboard/user-table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { formatCurrency } from "@/lib/format.utils";
import { SearchIcon } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { User } from "@/types/user";
import { ManualPaginationControl } from "@/components/ManualPagination";
import {
  MetricsService,
  type DashboardMetrics,
} from "@/api/metrics-service";

function mapMetricsToCards(data: DashboardMetrics) {
  return [
    { title: "Total booking", value: String(data.totalBookings ?? 0) },
    { title: "Total apartments", value: String(data.totalApartments ?? 0) },
    { title: "Total rides", value: String(data.totalRides ?? 0) },
    { title: "Total chefs", value: String(data.totalChefs ?? 0) },
    {
      title: "Earnings",
      value: formatCurrency(data.totalEarnings ?? 0),
      fontSize: "30px",
    },
  ];
}

export default function Dashboard() {
  const [searchTerm, setSearchTerm] = useState("");
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState("");
  const [status, setStatus] = useState("all");
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState({
    pageIndex: 0,
    pageSize: 10,
  });
  const [totalPages, setTotalPages] = useState<number>(1);
  const [actionLoadingUserId, setActionLoadingUserId] = useState<string | null>(
    null,
  );

  const cachedOnMount = MetricsService.getCachedMetrics();
  const [metricsData, setMetricsData] = useState(() =>
    cachedOnMount ? mapMetricsToCards(cachedOnMount) : [],
  );
  const [metricsLoading, setMetricsLoading] = useState(!cachedOnMount);

  useEffect(() => {
    let cancelled = false;

    MetricsService.getDashboardMetrics().then((data) => {
      if (cancelled || !data) return;
      setMetricsData(mapMetricsToCards(data));
      setMetricsLoading(false);
    });

    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    const t = setTimeout(() => setDebouncedSearchTerm(searchTerm), 350);
    return () => clearTimeout(t);
  }, [searchTerm]);

  const fetchUsers = useCallback(() => {
    setLoading(true);
    UserService.getAllUsers({
      page: pagination.pageIndex + 1,
      limit: pagination.pageSize,
      searchTerm: debouncedSearchTerm || undefined,
      ...(status !== "all" && {
        isEmailVerified: status === "verified" ? "true" : "false",
      }),
    })
      .then((response) => {
        setUsers(response.data);
        setTotalPages(response.pagination.totalPages);
      })
      .finally(() => {
        setLoading(false);
      });
  }, [
    pagination.pageIndex,
    pagination.pageSize,
    debouncedSearchTerm,
    status,
  ]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const handleApproveUser = async (userId: string) => {
    setActionLoadingUserId(userId);
    try {
      await UserService.updateKycStatus(userId, "verified");
      fetchUsers();
    } finally {
      setActionLoadingUserId(null);
    }
  };

  const handleDeclineUser = async (userId: string) => {
    setActionLoadingUserId(userId);
    try {
      await UserService.updateKycStatus(userId, "declined");
      fetchUsers();
    } finally {
      setActionLoadingUserId(null);
    }
  };

  const metricTitles = [
    "Total booking",
    "Total apartments",
    "Total rides",
    "Total chefs",
    "Earnings",
  ];

  const cardsToShow =
    metricsData.length > 0
      ? metricsData
      : metricTitles.map((title) => ({ title, value: "" }));

  return (
    <div className="w-full ">
      <div className="pt-[60px] pl-[40px] pr-[60px] pb-[50px] space-y-3">
        <h3 className="text-xl font-semibold">Welcome back</h3>
        <div className="w-full flex gap-6 flex-wrap">
          {cardsToShow.map((metric, index) => (
            <MetricCard
              key={metric.title}
              title={metric.title}
              value={metric.value}
              fontSize={
                metric.title === "Earnings" ? "30px" : undefined
              }
              loading={metricsLoading}
            />
          ))}
        </div>
      </div>

      <div className="w-full">
        <div className="w-full px-10 py-3 text-lg font-semibold border-t border-gray-100 mt-4">
          Users
        </div>
        <div className="w-full px-10 pt-5 pb-16 space-y-6">
          <div className="w-full flex flex-wrap items-center justify-between gap-5">
            <div className="flex-1 max-w-[600px] flex gap-3">
              <div className="flex-1 rounded-lg bg-gray-100 px-4 py-2 flex items-center gap-2 border border-transparent focus-within:border-primary-500 focus-within:bg-white transition-all shadow-sm">
                <SearchIcon size={18} className="text-gray-400" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full bg-transparent border-none outline-none text-[14px] placeholder:text-gray-400"
                  placeholder="Search by Email, Phone, or Name..."
                />
              </div>
              <button
                type="button"
                onClick={() => setDebouncedSearchTerm(searchTerm)}
                className="bg-primary-500 hover:bg-primary-600 text-dark font-medium rounded-lg px-6 py-2 text-[14px] transition-colors shadow-sm"
              >
                Search
              </button>
            </div>
            <div className="flex items-center gap-3">
              <span className="text-[13px] font-medium text-gray-400">
                Sort by:
              </span>
              <Select onValueChange={setStatus} value={status}>
                <SelectTrigger className="w-[160px] h-10 px-3 flex gap-2 text-dark border-gray-200 rounded-lg bg-white text-[13px] shadow-sm">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Users</SelectItem>
                  <SelectItem value="verified">Verified Only</SelectItem>
                  <SelectItem value="not-verified">Not Verified</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="w-full space-y-4">
            <div className="flex items-baseline justify-between">
              <span className="text-sm font-medium text-gray-500">
                Found {users.length} users
              </span>
            </div>

            <UserTable
              users={users}
              loading={loading}
              actionLoadingUserId={actionLoadingUserId}
              onApproveUser={handleApproveUser}
              onDeclineUser={handleDeclineUser}
            />

            {users.length === 0 && !loading && (
              <div className="flex flex-col items-center justify-center py-20 bg-white border rounded-xl shadow-sm">
                <SearchIcon size={48} className="text-gray-200 mb-4" />
                <h3 className="text-lg font-semibold text-gray-900">
                  No users found
                </h3>
                <p className="text-gray-500 max-w-xs text-center mt-1">
                  We couldn't find any users matching your current search or
                  filter.
                </p>
              </div>
            )}

            <div className="pt-4">
              <ManualPaginationControl
                pageIndex={pagination.pageIndex}
                pageSize={pagination.pageSize}
                totalPages={totalPages}
                onChange={(pagination) => setPagination(pagination)}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
