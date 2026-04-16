"use client";

import { useQuery } from "@tanstack/react-query";
import { ProtectedShell } from "@/components/layout/protected-shell";
import { getApartments, getChefs, getRides } from "@/lib/api/catalog";
import { useSessionStore } from "@/lib/session/store";

function ListingCard({
  title,
  subtitle,
  badge,
}: {
  title: string;
  subtitle: string;
  badge: string;
}) {
  return (
    <div className="rounded-xl border bg-white p-4">
      <div className="mb-2 inline-flex rounded-full bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700">
        {badge}
      </div>
      <h3 className="text-sm font-semibold text-zinc-900">{title}</h3>
      <p className="mt-1 text-xs text-zinc-600">{subtitle}</p>
    </div>
  );
}

export default function ExplorePage() {
  const role = useSessionStore((state) => state.role);
  const activeRole = role ?? "user";

  const apartmentsQuery = useQuery({
    queryKey: ["catalog", "apartments"],
    queryFn: getApartments,
  });
  const ridesQuery = useQuery({
    queryKey: ["catalog", "rides"],
    queryFn: getRides,
  });

  const resolveSubtitle = (item: {
    location?: string | { type?: string; coordinates?: number[] };
    address?: string;
  }) => {
    if (typeof item.location === "string" && item.location.trim()) return item.location;
    if (item.address?.trim()) return item.address;
    return "Location unavailable";
  };
  const chefsQuery = useQuery({
    queryKey: ["catalog", "chefs"],
    queryFn: getChefs,
  });

  return (
    <ProtectedShell role={activeRole} title="Explore Apartments and Rides">
      <div className="space-y-6">
        <section>
          <h2 className="mb-3 text-lg font-semibold text-zinc-900">Apartments</h2>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {(apartmentsQuery.data ?? []).slice(0, 9).map((item) => (
              <ListingCard
                key={item._id}
                badge="Apartment"
                title={item.title ?? item.name ?? "Apartment"}
                subtitle={resolveSubtitle(item)}
              />
            ))}
          </div>
        </section>

        <section>
          <h2 className="mb-3 text-lg font-semibold text-zinc-900">Rides</h2>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {(ridesQuery.data ?? []).slice(0, 9).map((item) => (
              <ListingCard
                key={item._id}
                badge="Ride"
                title={item.title ?? item.name ?? "Ride"}
                subtitle={resolveSubtitle(item)}
              />
            ))}
          </div>
        </section>

        <section>
          <h2 className="mb-3 text-lg font-semibold text-zinc-900">Chefs</h2>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {(chefsQuery.data ?? []).slice(0, 9).map((chef) => (
              <ListingCard
                key={chef._id}
                badge="Chef"
                title={chef.fullName ?? "Chef"}
                subtitle={chef.address ?? "Location unavailable"}
              />
            ))}
          </div>
        </section>
      </div>
    </ProtectedShell>
  );
}
