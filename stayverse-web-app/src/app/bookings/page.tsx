"use client";

import { useQuery } from "@tanstack/react-query";
import { ProtectedShell } from "@/components/layout/protected-shell";
import { getBookings } from "@/lib/api/bookings";
import { useSessionStore } from "@/lib/session/store";
import type { AppRole } from "@/lib/types";

export default function BookingsPage() {
  const role = useSessionStore((state) => state.role);
  const activeRole: AppRole = role ?? "user";

  const bookingsQuery = useQuery({
    queryKey: ["bookings", activeRole],
    queryFn: () => getBookings(activeRole),
  });

  return (
    <ProtectedShell role={activeRole} title="Bookings">
      <div className="rounded-xl border bg-white">
        <div className="border-b px-4 py-3">
          <h2 className="text-base font-semibold text-zinc-900">Recent Bookings</h2>
          <p className="text-xs text-zinc-600">
            Pulled from the same booking endpoints used in mobile.
          </p>
        </div>
        <div className="divide-y">
          {(bookingsQuery.data ?? []).slice(0, 20).map((booking) => (
            <div key={booking._id} className="flex items-center justify-between px-4 py-3">
              <div>
                <p className="text-sm font-medium text-zinc-900">{booking._id}</p>
                <p className="text-xs text-zinc-500">
                  {booking.serviceType ?? "service"} - {booking.status ?? "pending"}
                </p>
              </div>
              <p className="text-sm text-zinc-700">{booking.totalAmount ?? "-"}</p>
            </div>
          ))}
          {bookingsQuery.data?.length === 0 && (
            <div className="px-4 py-6 text-sm text-zinc-500">No bookings found.</div>
          )}
        </div>
      </div>
    </ProtectedShell>
  );
}
