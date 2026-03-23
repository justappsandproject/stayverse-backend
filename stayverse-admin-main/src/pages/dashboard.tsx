import { UserService } from "@/api/user-service";
import MetricCard from "@/components/dashboard/metrics-card";
// import UserInfoCard from "@/components/dashboard/user-info-card";
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
import { useEffect, useState } from "react";
import { User } from "@/types/user";
import { ManualPaginationControl } from "@/components/ManualPagination";
import { MetricsService, type DashboardMetrics } from "@/api/metrics-service";

export default function Dashboard() {
  const [searchTerm, setSearchTerm] = useState("");
  const [status, setStatus] = useState("all");
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState<{
    pageIndex: number;
    pageSize: number;
  }>({
    pageIndex: 0,
    pageSize: 10,
  });
  const [totalPages, setTotalPages] = useState<number>(1);

  const defaultMetrics = [
    { title: "Total booking", value: "0" },
    { title: "Total apartments", value: "0" },
    { title: "Total rides", value: "0" },
    { title: "Total chefs", value: "0" },
    { title: "Earnings", value: formatCurrency(0) },
  ];

  const [metricsData, setMetricsData] = useState<
    { title: string; value: string; fontSize?: string }[]
  >([]);

  useEffect(() => {
    MetricsService.getDashboardMetrics().then((data: DashboardMetrics) => {
      if (!data) return;
      const mapped = [
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
      setMetricsData(mapped);
    });
  }, []);

  useEffect(() => {
    setLoading(true);
    UserService.getAllUsers({
      page: pagination.pageIndex + 1,
      limit: pagination.pageSize,
      searchTerm,
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
  }, [pagination.pageIndex, pagination.pageSize, searchTerm, status]);

  return (
    <div className="w-full ">
      <div className="pt-[60px] pl-[40px] pr-[60px] pb-[50px] space-y-3">
        <h3 className="text-xl font-semibold">Welcome back</h3>
        <div className="w-full flex gap-6 flex-wrap">
          {(metricsData.length ? metricsData : defaultMetrics).map(
            (metric, index) => (
              <MetricCard
                key={index}
                title={metric.title}
                value={metric.value}
              />
            ),
          )}
        </div>
      </div>

      <div className="w-full">
        <div className="w-full px-10 py-3 text-lg font-semibold border-t border-gray-100 mt-4">
          Users
        </div>
        {/* <hr className="border-t-[0.3px] border-[#989898] " /> */}
        <div className="w-full px-10 pt-5 pb-16 space-y-6">
          {/* Search and filter components */}
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
                type="submit"
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

          {/* Search results */}
          <div className="w-full space-y-4">
            <div className="flex items-baseline justify-between">
              <span className="text-sm font-medium text-gray-500">
                Found {users.length} users
              </span>
            </div>

            <UserTable users={users} loading={loading} />

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
