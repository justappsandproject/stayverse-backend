"use client";

import type { BookingRecord, ServiceListing } from "@/lib/types";

export function UserHomeHeader({ firstname }: { firstname?: string }) {
  return (
    <div className="rounded-2xl border border-[#FDE6AF] bg-white p-4">
      <p className="text-2xl font-semibold text-black">
        Hi <span className="text-[#FBC036]">{firstname ?? "there"}</span>
      </p>
      <p className="mt-1 text-2xl font-semibold text-black">Let&apos;s start exploring! 🙂</p>
    </div>
  );
}

export function UserSearchBar() {
  return (
    <div className="rounded-xl border border-[#E2E0DD] bg-white p-3">
      <div className="rounded-xl bg-[#F4F4F4] px-4 py-3 text-sm text-[#8F8F8F]">
        Search apartments, rides, chefs...
      </div>
    </div>
  );
}

export function UserCategoryTabs({
  tab,
  onChange,
}: {
  tab: "apartments" | "rides" | "chefs";
  onChange: (tab: "apartments" | "rides" | "chefs") => void;
}) {
  const tabs: Array<{ key: "apartments" | "rides" | "chefs"; label: string }> = [
    { key: "apartments", label: "Apartments" },
    { key: "rides", label: "Rides" },
    { key: "chefs", label: "Chefs" },
  ];
  return (
    <div className="grid grid-cols-3 gap-2">
      {tabs.map((item) => (
        <button
          key={item.key}
          className={`rounded-xl px-3 py-2 text-xs font-semibold ${
            tab === item.key ? "bg-[#FBC036] text-black" : "bg-white border border-[#E2E0DD] text-[#7D7873]"
          }`}
          onClick={() => onChange(item.key)}
        >
          {item.label}
        </button>
      ))}
    </div>
  );
}

export function UserListings({
  title,
  items,
}: {
  title: string;
  items: ServiceListing[];
}) {
  const resolveSubtitle = (item: ServiceListing) => {
    if (typeof item.location === "string" && item.location.trim()) return item.location;
    if (item.address?.trim()) return item.address;
    return "Location unavailable";
  };

  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
      <h3 className="text-sm font-semibold text-[#2C2C2C]">{title}</h3>
      <div className="mt-3 space-y-2">
        {items.length === 0 && <p className="text-xs text-[#8F8F8F]">No listings available.</p>}
        {items.map((item) => (
          <div key={item._id} className="rounded-xl bg-[#F7F7F7] px-3 py-2">
            <p className="text-sm font-medium text-[#2C2C2C]">{item.title ?? item.name ?? "Listing"}</p>
            <p className="text-xs text-[#7D7873]">{resolveSubtitle(item)}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export function UserBookingsPanel({ bookings }: { bookings: BookingRecord[] }) {
  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
      <h3 className="text-sm font-semibold text-[#2C2C2C]">Bookings</h3>
      <div className="mt-3 space-y-2">
        {bookings.length === 0 && <p className="text-xs text-[#8F8F8F]">No bookings found.</p>}
        {bookings.map((booking) => (
          <div key={booking._id} className="rounded-xl bg-[#F7F7F7] px-3 py-2">
            <p className="text-xs text-[#8F8F8F]">{booking._id}</p>
            <p className="text-sm font-medium capitalize text-[#2C2C2C]">
              {booking.serviceType ?? "service"} - {booking.status ?? "pending"}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}
