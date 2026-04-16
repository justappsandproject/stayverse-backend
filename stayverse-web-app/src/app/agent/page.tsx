"use client";

import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { getMe } from "@/lib/api/auth";
import { getBookings } from "@/lib/api/bookings";
import { getApartments, getRides } from "@/lib/api/catalog";
import { getWalletTransactions } from "@/lib/api/wallet";
import { MobileDashboardShell } from "@/components/layout/mobile-dashboard-shell";
import { InboxPanel, ProfilePanel, WalletPanel } from "@/components/dashboard/shared-mobile-panels";
import {
  AgentBookingTabs,
  AgentMetricGrid,
  AgentOverviewHeader,
} from "@/components/dashboard/agent-mobile-sections";
import { useSessionStore } from "@/lib/session/store";

export default function AgentDashboardPage() {
  const [activeTab, setActiveTab] = useState("discover");
  const [period, setPeriod] = useState<"This Week" | "This Month" | "This Year">("This Week");
  const [bookingTab, setBookingTab] = useState<"pending" | "booked" | "completed">("pending");
  const profile = useSessionStore((state) => state.profile);
  const setSession = useSessionStore((state) => state.setSession);
  const token = useSessionStore((state) => state.token);

  const meQuery = useQuery({
    queryKey: ["me", "agent"],
    queryFn: () => getMe("agent"),
    enabled: Boolean(token),
  });

  useEffect(() => {
    if (meQuery.data && token) {
      setSession({ token, role: "agent", profile: meQuery.data });
    }
  }, [meQuery.data, setSession, token]);

  const ridesQuery = useQuery({
    queryKey: ["dashboard", "agent", "rides"],
    queryFn: getRides,
  });
  const apartmentsQuery = useQuery({
    queryKey: ["dashboard", "agent", "apartments"],
    queryFn: getApartments,
  });
  const bookingsQuery = useQuery({
    queryKey: ["dashboard", "agent", "bookings"],
    queryFn: () => getBookings("agent"),
  });
  const walletTransactionsQuery = useQuery({
    queryKey: ["dashboard", "agent", "wallet-transactions"],
    queryFn: getWalletTransactions,
  });

  const activeProfile = meQuery.data ?? profile;
  const serviceType = activeProfile?.agent?.serviceType ?? "apartment";
  const middleLabel = serviceType === "ride" ? "Add Vehicle" : "Add Property";
  const inventory = serviceType === "ride" ? ridesQuery.data : apartmentsQuery.data;
  const filteredBookings = (bookingsQuery.data ?? []).filter((booking) => {
    if (bookingTab === "booked") return booking.status === "accepted" || booking.status === "booked";
    if (bookingTab === "completed") return booking.status === "completed";
    return booking.status === "pending" || !booking.status;
  });

  return (
    <MobileDashboardShell
      role="agent"
      activeTab={activeTab}
      onTabChange={setActiveTab}
      tabs={[
        { key: "discover", label: "Discover", icon: "D" },
        { key: "wallet", label: "Wallet", icon: "W" },
        { key: "add", label: middleLabel, icon: "+" },
        { key: "inbox", label: "Inbox", icon: "I" },
        { key: "me", label: "Me", icon: "M" },
      ]}
    >
      <div className="space-y-4">
        {activeTab === "discover" && (
          <>
            <AgentOverviewHeader
              firstname={activeProfile?.firstname}
              period={period}
              onPeriodChange={setPeriod}
            />
            <AgentMetricGrid bookings={bookingsQuery.data ?? []} listings={inventory?.length ?? 0} />
            <AgentBookingTabs tab={bookingTab} onChange={setBookingTab} />

            <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
              <h3 className="text-sm font-semibold text-[#2C2C2C]">Bookings - {bookingTab}</h3>
              <div className="mt-3 space-y-2">
                {filteredBookings.slice(0, 8).map((item) => (
                  <div key={item._id} className="rounded-xl bg-[#F7F7F7] px-3 py-2">
                    <p className="text-sm font-medium capitalize text-[#2C2C2C]">
                      {item.serviceType ?? "service"} - {item.status ?? "pending"}
                    </p>
                    <p className="text-xs text-[#7D7873]">Booking ID: {item._id}</p>
                  </div>
                ))}
              </div>
            </div>
          </>
        )}

        {activeTab === "wallet" && (
          <WalletPanel
            balance={Number(activeProfile?.balance ?? 0)}
            transactions={walletTransactionsQuery.data ?? []}
          />
        )}

        {activeTab === "add" && (
          <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
            <h3 className="text-sm font-semibold text-[#2C2C2C]">{middleLabel}</h3>
            <p className="mt-2 text-sm text-[#7D7873]">
              {serviceType === "ride"
                ? "Vehicle creation area aligned to the mobile add-listing tab."
                : "Property creation area aligned to the mobile add-listing tab."}
            </p>
          </div>
        )}

        {activeTab === "inbox" && (
          <InboxPanel />
        )}

        {activeTab === "me" && (
          <ProfilePanel profile={activeProfile} agentMode />
        )}
      </div>
    </MobileDashboardShell>
  );
}
