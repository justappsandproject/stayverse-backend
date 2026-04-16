"use client";

import { useRouter } from "next/navigation";
import { useSessionStore } from "@/lib/session/store";

export default function KycPage() {
  const router = useRouter();
  const profile = useSessionStore((state) => state.profile);
  const status = profile?.kycStatus?.toLowerCase();

  const kycLabel =
    status === "verified" || status === "approved"
      ? "Approved"
      : status === "declined" || status === "rejected"
        ? "Declined"
        : status === "in_review"
          ? "In Review"
          : "Pending";

  const badgeClass =
    kycLabel === "Approved"
      ? "bg-green-100 text-green-700"
      : kycLabel === "Declined"
        ? "bg-red-100 text-red-700"
        : kycLabel === "In Review"
          ? "bg-gray-100 text-gray-700"
          : "bg-amber-100 text-amber-700";

  return (
    <main className="min-h-screen bg-white">
      <div className="mx-auto max-w-xl">
        <header className="flex items-center justify-between border-b border-[#F2F2F2] px-4 py-3">
          <button onClick={() => router.back()} className="text-xl text-[#2C2C2C]" aria-label="Go back">
            ←
          </button>
          <h1 className="text-xl font-medium text-black">KYC</h1>
          <span className="w-5" />
        </header>

        <section className="px-4 py-5">
          <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
            <p className="text-sm text-[#7D7873]">Verification Status</p>
            <span className={`mt-2 inline-flex rounded-md px-2.5 py-1 text-xs font-medium ${badgeClass}`}>
              {kycLabel}
            </span>
            <p className="mt-3 text-sm text-[#514F4D]">
              This page mirrors the mobile KYC placement. If your status is pending, complete verification from the
              mobile app while web upload parity is being finalized.
            </p>
          </div>
        </section>
      </div>
    </main>
  );
}
