"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { useSessionStore } from "@/lib/session/store";
import type { AppRole } from "@/lib/types";

export function ProtectedShell({
  role,
  title,
  children,
}: {
  role: AppRole;
  title: string;
  children: React.ReactNode;
}) {
  const router = useRouter();
  const sessionRole = useSessionStore((state) => state.role);
  const hydrated = useSessionStore((state) => state.hydrated);
  const clearSession = useSessionStore((state) => state.clearSession);

  useEffect(() => {
    if (!hydrated) return;
    if (!sessionRole) {
      router.replace("/");
      return;
    }
    if (sessionRole !== role) {
      router.replace(sessionRole === "agent" ? "/agent" : "/user");
    }
  }, [hydrated, role, router, sessionRole]);

  if (!hydrated || !sessionRole) {
    return <div className="p-6 text-sm text-zinc-500">Loading session...</div>;
  }

  return (
    <main className="min-h-screen bg-zinc-50">
      <header className="sticky top-0 z-20 border-b border-zinc-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
          <h1 className="text-lg font-semibold text-zinc-900">{title}</h1>
          <div className="flex items-center gap-2 text-sm">
            <Link className="rounded-lg border px-3 py-1.5" href="/explore">
              Explore
            </Link>
            <Link className="rounded-lg border px-3 py-1.5" href="/bookings">
              Bookings
            </Link>
            <button
              className="rounded-lg bg-zinc-900 px-3 py-1.5 text-white"
              onClick={() => {
                clearSession();
                router.replace("/");
              }}
            >
              Log out
            </button>
          </div>
        </div>
      </header>
      <section className="mx-auto max-w-6xl px-4 py-6">{children}</section>
    </main>
  );
}
