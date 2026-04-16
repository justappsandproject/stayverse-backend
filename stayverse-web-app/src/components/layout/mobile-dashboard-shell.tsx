"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useSessionStore } from "@/lib/session/store";
import type { AppRole } from "@/lib/types";

export type DashboardTab = {
  key: string;
  label: string;
  icon: string;
};

export function MobileDashboardShell({
  role,
  tabs,
  activeTab,
  onTabChange,
  children,
}: {
  role: AppRole;
  tabs: DashboardTab[];
  activeTab: string;
  onTabChange: (key: string) => void;
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
    return <div className="min-h-screen p-6 text-sm text-zinc-500">Loading dashboard...</div>;
  }

  return (
    <main className="min-h-screen bg-[#fffaf0]">
      <section className="mx-auto max-w-xl px-4 pb-28 pt-6">{children}</section>

      <nav className="fixed inset-x-0 bottom-0 z-30 border-t border-[#E2E0DD] bg-white/95 backdrop-blur">
        <div className="mx-auto grid max-w-xl grid-cols-5 px-2 py-2">
          {tabs.map((tab) => {
            const active = tab.key === activeTab;
            return (
              <button
                key={tab.key}
                type="button"
                onClick={() => onTabChange(tab.key)}
                className={`flex flex-col items-center justify-center rounded-xl px-2 py-1 text-xs font-medium ${
                  active ? "text-[#2C2C2C]" : "text-[#8F8F8F]"
                }`}
              >
                <span
                  className={`mb-1 inline-flex h-7 w-7 items-center justify-center rounded-full text-sm ${
                    active ? "bg-[#FBC036] text-black" : "bg-[#F7F7F7]"
                  }`}
                >
                  {tab.icon}
                </span>
                {tab.label}
              </button>
            );
          })}
        </div>
        <div className="mx-auto max-w-xl px-4 pb-2">
          <button
            className="w-full rounded-lg border border-[#E2E0DD] py-2 text-xs font-semibold text-[#7D7873]"
            onClick={() => {
              clearSession();
              router.replace("/");
            }}
          >
            Log out
          </button>
        </div>
      </nav>
    </main>
  );
}
