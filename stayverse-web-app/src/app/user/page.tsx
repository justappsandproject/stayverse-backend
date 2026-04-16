"use client";

import { useQuery } from "@tanstack/react-query";
import { useEffect, useMemo, useState } from "react";
import { getMe } from "@/lib/api/auth";
import { getFavorites } from "@/lib/api/favorites";
import { getBookings } from "@/lib/api/bookings";
import { getApartments, getChefs, getRides } from "@/lib/api/catalog";
import { MobileDashboardShell } from "@/components/layout/mobile-dashboard-shell";
import {
  FavouritePanel,
  InboxPanel,
  ProfilePanel,
} from "@/components/dashboard/shared-mobile-panels";
import {
  UserBookingsPanel,
  UserCategoryTabs,
  UserHomeHeader,
  UserListings,
  UserSearchBar,
} from "@/components/dashboard/user-mobile-sections";
import { useSessionStore } from "@/lib/session/store";

export default function UserDashboardPage() {
  const [activeTab, setActiveTab] = useState("discover");
  const [discoverTab, setDiscoverTab] = useState<"apartments" | "rides" | "chefs">("apartments");
  const profile = useSessionStore((state) => state.profile);
  const setSession = useSessionStore((state) => state.setSession);
  const token = useSessionStore((state) => state.token);

  const meQuery = useQuery({
    queryKey: ["me", "user"],
    queryFn: () => getMe("user"),
    enabled: Boolean(token),
  });

  useEffect(() => {
    if (meQuery.data && token) {
      setSession({ token, role: "user", profile: meQuery.data });
    }
  }, [meQuery.data, setSession, token]);

  const apartmentsQuery = useQuery({
    queryKey: ["dashboard", "user", "apartments"],
    queryFn: getApartments,
  });
  const ridesQuery = useQuery({
    queryKey: ["dashboard", "user", "rides"],
    queryFn: getRides,
  });
  const chefsQuery = useQuery({
    queryKey: ["dashboard", "user", "chefs"],
    queryFn: getChefs,
  });
  const bookingsQuery = useQuery({
    queryKey: ["dashboard", "user", "bookings"],
    queryFn: () => getBookings("user"),
  });
  const favouritesQuery = useQuery({
    queryKey: ["dashboard", "user", "favourites"],
    queryFn: getFavorites,
  });

  const activeProfile = meQuery.data ?? profile;
  const discoverItems = useMemo(() => {
    if (discoverTab === "rides") return ridesQuery.data ?? [];
    if (discoverTab === "chefs") {
      return (chefsQuery.data ?? []).map((chef) => ({
        _id: chef._id,
        title: chef.fullName ?? "Chef",
        location: chef.address ?? "Location unavailable",
      }));
    }
    return apartmentsQuery.data ?? [];
  }, [apartmentsQuery.data, chefsQuery.data, discoverTab, ridesQuery.data]);

  return (
    <MobileDashboardShell
      role="user"
      activeTab={activeTab}
      onTabChange={setActiveTab}
      tabs={[
        { key: "discover", label: "Discover", icon: "D" },
        { key: "favourite", label: "Favourite", icon: "F" },
        { key: "bookings", label: "Bookings", icon: "B" },
        { key: "inbox", label: "Inbox", icon: "I" },
        { key: "me", label: "Me", icon: "M" },
      ]}
    >
      <div className="space-y-4">
        {activeTab === "discover" && (
          <>
            <UserHomeHeader firstname={activeProfile?.firstname} />
            <UserSearchBar />
            <UserCategoryTabs tab={discoverTab} onChange={setDiscoverTab} />
            <UserListings
              title={
                discoverTab === "apartments"
                  ? "Recommended Apartments"
                  : discoverTab === "rides"
                    ? "Recommended Rides"
                    : "Top Chefs"
              }
              items={discoverItems.slice(0, 8)}
            />
          </>
        )}

        {activeTab === "bookings" && (
          <UserBookingsPanel bookings={(bookingsQuery.data ?? []).slice(0, 12)} />
        )}

        {activeTab === "favourite" && (
          <FavouritePanel favourites={favouritesQuery.data ?? []} />
        )}

        {activeTab === "inbox" && (
          <InboxPanel />
        )}

        {activeTab === "me" && (
          <ProfilePanel profile={activeProfile} />
        )}
      </div>
    </MobileDashboardShell>
  );
}
