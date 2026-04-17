"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { toast } from "sonner";
import type { CuratedMessage, FavoriteRecord, SessionUser, WalletTransaction } from "@/lib/types";
import { useSessionStore } from "@/lib/session/store";
import { deleteMyAccount, updateNotificationPreference, updatePassword } from "@/lib/api/profile";
import { fundWallet, requestWithdrawal } from "@/lib/api/wallet";
import { getCuratedMessages } from "@/lib/api/notifications";

export function FavouritePanel({ favourites }: { favourites: FavoriteRecord[] }) {
  const [tab, setTab] = useState<"apartments" | "rides" | "chefs">("apartments");
  const apartmentItems = favourites.filter((item) => item.serviceType === "apartment" && item.apartment);
  const rideItems = favourites.filter((item) => item.serviceType === "ride" && item.ride);
  const chefItems = favourites.filter((item) => item.serviceType === "chef" && item.chef);

  const activeCount =
    tab === "apartments" ? apartmentItems.length : tab === "rides" ? rideItems.length : chefItems.length;

  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
      <h3 className="text-xl font-medium text-black">Favourite</h3>

      <div className="mt-4 grid grid-cols-3 gap-2">
        {[
          { key: "apartments", label: "Apartments" },
          { key: "rides", label: "Rides" },
          { key: "chefs", label: "Chefs" },
        ].map((item) => (
          <button
            key={item.key}
            onClick={() => setTab(item.key as "apartments" | "rides" | "chefs")}
            className={`rounded-xl border px-2 py-2 text-xs font-medium transition ${
              tab === item.key ? "border-[#FBC036] bg-[#FFF5DE] text-black" : "border-[#E2E0DD] bg-white text-[#8F8F8F]"
            }`}
          >
            {item.label}
          </button>
        ))}
      </div>

      {activeCount === 0 && (
        <div className="py-10 text-center">
          <p className="text-sm text-[#8F8F8F]">
            {tab === "apartments"
              ? "No Favourite Apartment Found"
              : tab === "rides"
                ? "No Car Rental Found"
                : "No Top Chefs found"}
          </p>
        </div>
      )}

      {tab === "apartments" && apartmentItems.length > 0 && (
        <div className="mt-4 grid grid-cols-2 gap-3">
          {apartmentItems.map((fav) => (
            <div key={fav._id} className="rounded-2xl border border-[#E2E0DD] bg-[#F7F7F7] p-3">
              <p className="truncate text-sm font-semibold text-[#2C2C2C]">{fav.apartment?.title ?? "Apartment"}</p>
              <p className="mt-1 line-clamp-2 text-xs text-[#7D7873]">
                {fav.apartment?.address ?? "Apartment listing"}
              </p>
            </div>
          ))}
        </div>
      )}

      {tab === "rides" && rideItems.length > 0 && (
        <div className="mt-4 grid grid-cols-2 gap-3">
          {rideItems.map((fav) => (
            <div key={fav._id} className="rounded-2xl border border-[#E2E0DD] bg-[#F7F7F7] p-3">
              <p className="truncate text-sm font-semibold text-[#2C2C2C]">{fav.ride?.title ?? "Ride"}</p>
              <p className="mt-1 line-clamp-2 text-xs text-[#7D7873]">{fav.ride?.address ?? "Ride listing"}</p>
            </div>
          ))}
        </div>
      )}

      {tab === "chefs" && chefItems.length > 0 && (
        <div className="mt-4 space-y-3">
          {chefItems.map((fav) => (
            <div key={fav._id} className="flex items-center justify-between rounded-2xl border border-[#E2E0DD] bg-white px-3 py-3">
              <div className="flex items-center gap-3">
                <div className="flex h-11 w-11 items-center justify-center rounded-full bg-[#FBC036]/20 text-sm font-semibold text-[#2C2C2C]">
                  {`${fav.chef?.firstname?.[0] ?? ""}${fav.chef?.lastname?.[0] ?? ""}`.trim() || "C"}
                </div>
                <div>
                  <p className="text-sm font-semibold text-[#2C2C2C]">
                    {`${fav.chef?.firstname ?? ""} ${fav.chef?.lastname ?? ""}`.trim() || "Chef"}
                  </p>
                  <p className="text-xs text-[#7D7873]">Top chef listing</p>
                </div>
              </div>
              <span className="text-[#9A9A9A]">›</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export function InboxPanel() {
  const token = useSessionStore((state) => state.token);
  const role = useSessionStore((state) => state.role);
  const curatedMessagesQuery = useQuery({
    queryKey: ["curated-messages", role],
    queryFn: () => getCuratedMessages(1, 30),
    enabled: Boolean(token && role),
  });
  const messages = curatedMessagesQuery.data ?? [];

  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white p-4">
      <h3 className="text-xl font-medium text-black">Curated Messages</h3>
      <div className="mt-3">
        {curatedMessagesQuery.isLoading && (
          <p className="py-6 text-center text-sm text-[#8F8F8F]">Loading messages...</p>
        )}

        {!curatedMessagesQuery.isLoading && messages.length === 0 && (
          <p className="py-6 text-center text-sm text-[#8F8F8F]">No curated messages yet.</p>
        )}

        {messages.map((item, index) => (
          <CuratedMessageCard key={item._id ?? item.id ?? `${index}`} item={item} />
        ))}
      </div>
    </div>
  );
}

function CuratedMessageCard({ item }: { item: CuratedMessage }) {
  const createdAt = item.createdAt
    ? new Date(item.createdAt).toLocaleString("en-NG", {
        day: "2-digit",
        month: "short",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      })
    : "Recently";

  return (
    <div className="mt-2.5 rounded-xl border border-[#F1F1F1] bg-white p-3">
      <p className="text-base font-semibold text-black">{item.title}</p>
      <p className="mt-1 text-sm text-[#6E6E6E]">{item.body}</p>
      <p className="mt-2 text-xs text-[#9B9B9B]">{createdAt}</p>
    </div>
  );
}

export function ProfilePanel({ profile, agentMode = false }: { profile?: SessionUser | null; agentMode?: boolean }) {
  const router = useRouter();
  const clearSession = useSessionStore((state) => state.clearSession);
  const [notificationEnabled, setNotificationEnabled] = useState(true);
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [deletePassword, setDeletePassword] = useState("");

  const serviceType = profile?.agent?.serviceType?.toLowerCase();
  const firstOption = agentMode
    ? serviceType === "ride"
      ? "Listed Cars"
      : serviceType === "apartment"
        ? "Listed Properties"
        : "Chef Profile"
    : "Wallet";

  const options = agentMode
    ? [firstOption, "Notification", "Password", "Chat Support", "About", "KYC"]
    : [firstOption, "Notification", "Change Password", "Chat Support", "About", "KYC"];
  const role = agentMode ? "agent" : "user";

  const fullName = `${profile?.firstname ?? ""} ${profile?.lastname ?? ""}`.trim() || "Stayverse Account";
  const kycStatus = (profile as { kycStatus?: string } | null)?.kycStatus?.toLowerCase();
  const kycLabel =
    kycStatus === "verified" || kycStatus === "approved"
      ? "Approved"
      : kycStatus === "declined" || kycStatus === "rejected"
        ? "Declined"
        : kycStatus === "in_review"
          ? "In Review"
          : "Pending";

  const kycColorClass =
    kycLabel === "Approved"
      ? "bg-green-100 text-green-700"
      : kycLabel === "Declined"
        ? "bg-red-100 text-red-700"
        : kycLabel === "In Review"
          ? "bg-gray-100 text-gray-700"
          : "bg-amber-100 text-amber-700";

  const handleOptionAction = async (option: string) => {
    try {
      if (option === "Wallet") {
        router.push("/wallet");
        return;
      }
      if (option === "Listed Cars" || option === "Listed Properties" || option === "Chef Profile") {
        router.push("/explore");
        return;
      }
      if (option === "Chat Support") {
        window.open("https://tawk.to/chat/68d1171589caa6192613d1f4/1j5oc4b5e", "_blank");
        return;
      }
      if (option === "About") {
        window.open("https://www.stayversepro.com/", "_blank");
        return;
      }
      if (option === "KYC") {
        router.push("/kyc");
        return;
      }
      if (option === "Password" || option === "Change Password") {
        setShowPasswordModal(true);
        return;
      }
      if (option === "Notification") {
        const nextValue = !notificationEnabled;
        setNotificationEnabled(nextValue);
        await updateNotificationPreference(role, nextValue);
        toast.success(`Notifications ${nextValue ? "enabled" : "disabled"}.`);
      }
    } catch {
      toast.error("Action failed. Please try again.");
    }
  };

  return (
    <div className="rounded-2xl border border-[#E2E0DD] bg-white">
      <div className="flex items-center justify-between border-b border-[#F2F2F2] px-4 py-3">
        <h3 className="text-lg font-medium text-black">Profile</h3>
        <button className="rounded-md p-1 text-[#8F8F8F] hover:bg-[#F7F7F7]" aria-label="Edit profile">
          ✎
        </button>
      </div>

      <div className="px-4 pb-5 pt-4">
        <div className="mb-4 flex flex-col items-center">
          <div className="flex h-[90px] w-[90px] items-center justify-center rounded-full bg-[#FBC036]/20 text-3xl text-[#2C2C2C]">
            {(profile?.firstname?.slice(0, 1) ?? "U").toUpperCase()}
          </div>
          <p className="mt-3 text-[18px] font-semibold text-black">{fullName}</p>
          <p className="text-sm text-[#757575]">{profile?.email ?? "No email"}</p>
        </div>

        <div>
          {options.map((option) => (
            <div key={option} className="border-b border-[#F2F2F2] last:border-b-0">
              <button
                className="flex w-full items-center justify-between py-3 text-left"
                onClick={() => handleOptionAction(option)}
              >
                <span className="text-[15px] font-normal text-black">{option}</span>
                {option === "Notification" ? (
                  <span
                    className={`inline-flex h-6 w-11 items-center rounded-full px-1 transition ${
                      notificationEnabled ? "bg-[#FBC036]" : "bg-[#E2E0DD]"
                    }`}
                  >
                    <span
                      className={`h-4 w-4 rounded-full bg-white transition ${
                        notificationEnabled ? "translate-x-5" : "translate-x-0"
                      }`}
                    />
                  </span>
                ) : option === "KYC" ? (
                  <span className={`rounded-md px-2 py-0.5 text-[11px] font-medium ${kycColorClass}`}>
                    {kycLabel}
                  </span>
                ) : (
                  <span className="text-[18px] text-[#9A9A9A]">›</span>
                )}
              </button>
            </div>
          ))}
        </div>
        {showPasswordModal && (
          <ModalCard
            title="Change Password"
            description="Enter your current password and new password."
            onClose={() => {
              setShowPasswordModal(false);
              setOldPassword("");
              setNewPassword("");
            }}
            onConfirm={async () => {
              if (!oldPassword || !newPassword) {
                toast.warning("Please fill all password fields.");
                return;
              }
              try {
                await updatePassword(role, { oldPassword, newPassword });
                toast.success("Password updated successfully.");
                setShowPasswordModal(false);
                setOldPassword("");
                setNewPassword("");
              } catch {
                toast.error("Password update failed. Check old password and try again.");
              }
            }}
            confirmText="Update Password"
          >
            <input
              type="password"
              placeholder="Current password"
              value={oldPassword}
              onChange={(e) => setOldPassword(e.target.value)}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
            <input
              type="password"
              placeholder="New password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              className="mt-2 w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
          </ModalCard>
        )}

        {showDeleteModal && (
          <ModalCard
            title="Delete Account"
            description="This action is permanent. Enter password to continue."
            onClose={() => {
              setShowDeleteModal(false);
              setDeletePassword("");
            }}
            onConfirm={async () => {
              if (!deletePassword) {
                toast.warning("Password is required.");
                return;
              }
              try {
                await deleteMyAccount(role, deletePassword);
                toast.success("Account deleted successfully.");
                clearSession();
                router.replace("/");
              } catch {
                toast.error("Delete account failed. Please verify your password.");
              }
            }}
            confirmText="Delete Account"
            confirmDanger
          >
            <input
              type="password"
              placeholder="Password"
              value={deletePassword}
              onChange={(e) => setDeletePassword(e.target.value)}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
          </ModalCard>
        )}

        <button
          className="mt-6 w-full rounded-xl bg-black px-4 py-3 text-[16px] font-medium text-white"
          onClick={() => {
            clearSession();
            router.replace("/");
          }}
        >
          Log Out
        </button>
        <button
          className="mt-3 w-full text-center text-[15px] font-normal text-red-600 underline decoration-red-600"
          onClick={() => setShowDeleteModal(true)}
        >
          Delete Account
        </button>
      </div>
    </div>
  );
}

function ModalCard({
  title,
  description,
  children,
  onClose,
  onConfirm,
  confirmText,
  confirmDanger = false,
}: {
  title: string;
  description: string;
  children: React.ReactNode;
  onClose: () => void;
  onConfirm: () => void;
  confirmText: string;
  confirmDanger?: boolean;
}) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/35 px-4">
      <div className="w-full max-w-sm rounded-2xl bg-white p-4 shadow-xl">
        <h4 className="text-base font-semibold text-[#2C2C2C]">{title}</h4>
        <p className="mt-1 text-sm text-[#7D7873]">{description}</p>
        <div className="mt-3">{children}</div>
        <div className="mt-4 grid grid-cols-2 gap-2">
          <button
            className="rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm font-medium text-[#2C2C2C]"
            onClick={onClose}
          >
            Cancel
          </button>
          <button
            className={`rounded-xl px-3 py-2 text-sm font-medium text-white ${
              confirmDanger ? "bg-red-600" : "bg-black"
            }`}
            onClick={onConfirm}
          >
            {confirmText}
          </button>
        </div>
      </div>
    </div>
  );
}

export function WalletPanel({
  balance,
  transactions,
}: {
  balance: number;
  transactions: WalletTransaction[];
}) {
  const [showBalance, setShowBalance] = useState(false);
  const [showAddFunds, setShowAddFunds] = useState(false);
  const [showWithdraw, setShowWithdraw] = useState(false);
  const [amountInput, setAmountInput] = useState("");
  const [withdrawForm, setWithdrawForm] = useState({
    fullName: "",
    accountNumber: "",
    bankCode: "",
    amount: "",
    password: "",
  });
  const naira = new Intl.NumberFormat("en-NG");

  const formatDate = (date?: string) => {
    if (!date) return "Recently";
    const parsed = new Date(date);
    if (Number.isNaN(parsed.getTime())) return "Recently";
    return parsed.toLocaleDateString("en-NG", { day: "2-digit", month: "short", year: "numeric" });
  };

  return (
    <div className="space-y-3">
      <div className="bg-white px-1 py-1">
        <p className="text-sm font-normal text-[#B9B9B9]">My balance</p>
        <div className="mt-1 flex items-center gap-3">
          <p className="text-[38px] font-bold leading-none text-[#02080C]">
            {showBalance ? `N${naira.format(balance)}` : "****"}
          </p>
          <button
            className="text-[#B9B9B9]"
            onClick={() => setShowBalance((prev) => !prev)}
            aria-label="Toggle wallet balance visibility"
          >
            {showBalance ? (
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden>
                <path
                  d="M2 12C3.6 8.5 7.2 6 12 6C16.8 6 20.4 8.5 22 12C20.4 15.5 16.8 18 12 18C7.2 18 3.6 15.5 2 12Z"
                  stroke="currentColor"
                  strokeWidth="1.8"
                />
                <circle cx="12" cy="12" r="3.2" stroke="currentColor" strokeWidth="1.8" />
              </svg>
            ) : (
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden>
                <path
                  d="M2 12C3.6 8.5 7.2 6 12 6C16.8 6 20.4 8.5 22 12C20.4 15.5 16.8 18 12 18C7.2 18 3.6 15.5 2 12Z"
                  stroke="currentColor"
                  strokeWidth="1.8"
                />
                <circle cx="12" cy="12" r="3.2" stroke="currentColor" strokeWidth="1.8" />
                <path d="M4 4L20 20" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
              </svg>
            )}
          </button>
        </div>
        <div className="mt-3 flex items-center gap-4">
          <button
            className="rounded-lg border border-[#FBC036] bg-white px-3 py-2 text-sm font-normal text-black"
            onClick={() => setShowAddFunds(true)}
          >
            + Add Funds
          </button>
          <button
            className="rounded-lg border border-[#FBC036] bg-[#FBC036] px-3 py-2 text-sm font-normal text-black"
            onClick={() => setShowWithdraw(true)}
          >
            Withdraw
          </button>
        </div>
      </div>

      <div className="overflow-hidden rounded-none border-y border-[#E2E0DD]">
        <div className="bg-[#F7F7F7] px-4 py-3">
          <h3 className="text-sm font-normal text-[#B9B9B9]">Activities</h3>
        </div>
        <div className="bg-[#F7F7F7] px-3 pb-3">
          {transactions.length === 0 && <p className="px-1 py-4 text-xs text-[#8F8F8F]">No transactions yet.</p>}
          <div className="space-y-2">
            {transactions.slice(0, 12).map((transaction) => (
              <div key={transaction._id} className="flex items-start justify-between border-b border-[#D9D9D9] px-1 py-3 last:border-b-0">
                <div>
                  <p className="text-[13px] font-medium text-black">
                    {transaction.description?.trim() ||
                      (transaction.type === "credit" ? "Money Received" : "Money Sent")}
                  </p>
                  <div className="mt-0.5 flex items-center gap-2">
                    <p className="text-[11px] font-normal text-[#808080]">{formatDate(transaction.createdAt)}</p>
                    <span className="rounded px-1.5 py-0.5 text-[9px] font-medium capitalize text-[#2C2C2C] bg-black/5">
                      {transaction.status ?? "unknown"}
                    </span>
                  </div>
                </div>
                <p className="text-[13px] font-medium text-black">
                  {transaction.type === "credit" ? "+" : "-"}N{naira.format(transaction.amount ?? 0)}
                </p>
              </div>
            ))}
          </div>
        </div>
      </div>

      {showAddFunds && (
        <ModalCard
          title="Add Funds"
          description="Enter amount to fund your wallet."
          onClose={() => {
            setShowAddFunds(false);
            setAmountInput("");
          }}
          onConfirm={async () => {
            const amount = Number(amountInput.replace(/[^\d.]/g, ""));
            if (!amount || amount <= 0) {
              toast.warning("Enter a valid amount.");
              return;
            }
            try {
              const payload = await fundWallet(amount);
              const authorizationUrl =
                (payload as { authorizationUrl?: string }).authorizationUrl ??
                (payload as { authorization_url?: string }).authorization_url;
              if (authorizationUrl) {
                window.open(authorizationUrl, "_blank");
                toast.success("Payment initialized. Complete payment in opened tab.");
              } else {
                toast.info("Funding initialized.");
              }
              setShowAddFunds(false);
              setAmountInput("");
            } catch {
              toast.error("Unable to initialize wallet funding.");
            }
          }}
          confirmText="Continue"
        >
          <input
            placeholder="Amount (NGN)"
            value={amountInput}
            onChange={(e) => setAmountInput(e.target.value)}
            className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
          />
        </ModalCard>
      )}

      {showWithdraw && (
        <ModalCard
          title="Withdraw"
          description="Enter your bank details and account password."
          onClose={() => {
            setShowWithdraw(false);
            setWithdrawForm({
              fullName: "",
              accountNumber: "",
              bankCode: "",
              amount: "",
              password: "",
            });
          }}
          onConfirm={async () => {
            const amount = Number(withdrawForm.amount.replace(/[^\d.]/g, ""));
            if (
              !withdrawForm.fullName ||
              !withdrawForm.accountNumber ||
              !withdrawForm.bankCode ||
              !withdrawForm.password ||
              !amount
            ) {
              toast.warning("Please complete all withdrawal fields.");
              return;
            }
            try {
              await requestWithdrawal({
                fullName: withdrawForm.fullName,
                accountNumber: withdrawForm.accountNumber,
                bankCode: withdrawForm.bankCode,
                amount,
                password: withdrawForm.password,
              });
              toast.success("Withdrawal request submitted.");
              setShowWithdraw(false);
              setWithdrawForm({
                fullName: "",
                accountNumber: "",
                bankCode: "",
                amount: "",
                password: "",
              });
            } catch {
              toast.error("Withdrawal failed. Verify details and try again.");
            }
          }}
          confirmText="Submit"
        >
          <div className="space-y-2">
            <input
              placeholder="Full Name"
              value={withdrawForm.fullName}
              onChange={(e) => setWithdrawForm((prev) => ({ ...prev, fullName: e.target.value }))}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
            <input
              placeholder="Account Number"
              value={withdrawForm.accountNumber}
              onChange={(e) => setWithdrawForm((prev) => ({ ...prev, accountNumber: e.target.value }))}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
            <input
              placeholder="Bank Code"
              value={withdrawForm.bankCode}
              onChange={(e) => setWithdrawForm((prev) => ({ ...prev, bankCode: e.target.value }))}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
            <input
              placeholder="Amount (NGN)"
              value={withdrawForm.amount}
              onChange={(e) => setWithdrawForm((prev) => ({ ...prev, amount: e.target.value }))}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
            <input
              type="password"
              placeholder="Password"
              value={withdrawForm.password}
              onChange={(e) => setWithdrawForm((prev) => ({ ...prev, password: e.target.value }))}
              className="w-full rounded-xl border border-[#E2E0DD] px-3 py-2 text-sm outline-none"
            />
          </div>
        </ModalCard>
      )}
    </div>
  );
}
