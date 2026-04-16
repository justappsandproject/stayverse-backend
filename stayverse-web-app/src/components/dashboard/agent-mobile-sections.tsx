"use client";

import type { BookingRecord } from "@/lib/types";

export function AgentOverviewHeader({
  firstname,
  period,
  onPeriodChange,
}: {
  firstname?: string;
  period: "This Week" | "This Month" | "This Year";
  onPeriodChange: (period: "This Week" | "This Month" | "This Year") => void;
}) {
  const options: Array<"This Week" | "This Month" | "This Year"> = [
    "This Week",
    "This Month",
    "This Year",
  ];
  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
      <p className="text-2xl font-semibold text-black">
        Good day <span className="text-[#FBC036]">{firstname ?? "Agent"}</span> 🙂
      </p>
      <div className="mt-3 flex items-center justify-between">
        <h3 className="text-sm font-semibold text-[#2C2C2C]">Overview</h3>
        <select
          value={period}
          onChange={(e) => onPeriodChange(e.target.value as "This Week" | "This Month" | "This Year")}
          className="rounded-md bg-black px-3 py-1 text-xs font-medium text-white"
        >
          {options.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
}

export function AgentMetricGrid({
  bookings,
  listings,
}: {
  bookings: BookingRecord[];
  listings: number;
}) {
  const pending = bookings.filter((b) => b.status === "pending").length;
  const accepted = bookings.filter((b) => b.status === "accepted").length;
  const completed = bookings.filter((b) => b.status === "completed").length;
  const earnings = bookings.reduce((sum, b) => sum + (b.totalAmount ?? 0), 0);
  return (
    <div className="grid grid-cols-2 gap-3">
      <MetricCard title="Earnings" value={`N${earnings.toLocaleString()}`} highlight />
      <MetricCard title="Bookings" value={`${bookings.length}`} />
      <MetricCard title="Listings" value={`${listings}`} />
      <MetricCard title="Pending" value={`${pending + accepted - completed}`} />
    </div>
  );
}

export function AgentBookingTabs({
  tab,
  onChange,
}: {
  tab: "pending" | "booked" | "completed";
  onChange: (tab: "pending" | "booked" | "completed") => void;
}) {
  const tabs: Array<{ key: "pending" | "booked" | "completed"; label: string }> = [
    { key: "pending", label: "Pending" },
    { key: "booked", label: "Booked" },
    { key: "completed", label: "Completed" },
  ];
  return (
    <div className="grid grid-cols-3 gap-2">
      {tabs.map((item) => (
        <button
          key={item.key}
          onClick={() => onChange(item.key)}
          className={`rounded-xl px-3 py-2 text-xs font-semibold ${
            tab === item.key ? "bg-[#FBC036] text-black" : "bg-white border border-[#E2E0DD] text-[#7D7873]"
          }`}
        >
          {item.label}
        </button>
      ))}
    </div>
  );
}

function MetricCard({
  title,
  value,
  highlight,
}: {
  title: string;
  value: string;
  highlight?: boolean;
}) {
  return (
    <div className={`rounded-xl border p-3 ${highlight ? "border-[#FBC036] bg-[#FBC036]" : "border-[#E2E0DD] bg-white"}`}>
      <p className="text-[11px] text-[#514F4D]">{title}</p>
      <p className="mt-1 text-lg font-bold text-[#2C2C2C]">{value}</p>
    </div>
  );
}
