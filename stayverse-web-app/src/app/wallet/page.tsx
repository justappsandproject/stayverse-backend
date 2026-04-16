"use client";

import { useQuery } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { getWalletTransactions } from "@/lib/api/wallet";
import { useSessionStore } from "@/lib/session/store";
import { WalletPanel } from "@/components/dashboard/shared-mobile-panels";

export default function WalletPage() {
  const router = useRouter();
  const profile = useSessionStore((state) => state.profile);
  const role = useSessionStore((state) => state.role);
  const hydrated = useSessionStore((state) => state.hydrated);

  const walletTransactionsQuery = useQuery({
    queryKey: ["wallet", "transactions"],
    queryFn: getWalletTransactions,
    enabled: hydrated && Boolean(role),
  });

  if (!hydrated || !role) {
    return <div className="p-6 text-sm text-[#7D7873]">Loading wallet...</div>;
  }

  return (
    <main className="min-h-screen bg-white">
      <div className="mx-auto max-w-xl">
        <header className="flex items-center justify-between border-b border-[#F2F2F2] px-4 py-3">
          <button onClick={() => router.back()} className="text-xl text-[#2C2C2C]" aria-label="Go back">
            ←
          </button>
          <h1 className="text-xl font-medium text-black">Wallet</h1>
          <span className="w-5" />
        </header>

        <section className="px-4 py-4">
          <WalletPanel
            balance={Number(profile?.balance ?? 0)}
            transactions={walletTransactionsQuery.data ?? []}
          />
        </section>
      </div>
    </main>
  );
}
