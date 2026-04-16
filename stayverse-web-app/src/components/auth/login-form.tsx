"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { getMe, loginByRole } from "@/lib/api/auth";
import { useSessionStore } from "@/lib/session/store";
import type { AppRole } from "@/lib/types";
import { AuthBranding } from "@/components/auth/branding";

export function LoginForm() {
  const [role, setRole] = useState<AppRole>("user");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const router = useRouter();
  const setSession = useSessionStore((state) => state.setSession);
  const storedRole = useSessionStore((state) => state.role);
  const token = useSessionStore((state) => state.token);
  const hydrated = useSessionStore((state) => state.hydrated);

  useQuery({
    queryKey: ["restore-session", token, storedRole],
    enabled: hydrated && Boolean(token && storedRole),
    queryFn: async () => {
      const profile = await getMe(storedRole as AppRole);
      router.replace(storedRole === "agent" ? "/agent" : "/user");
      return profile;
    },
  });

  const mutation = useMutation({
    mutationFn: async () => {
      const loginResponse = await loginByRole(role, { email, password });
      const accessToken = loginResponse.accessToken ?? loginResponse.access_token;
      if (!accessToken) {
        throw new Error("No access token returned from API.");
      }
      // Persist token first so subsequent protected requests include Authorization.
      setSession({ token: accessToken, role, profile: null });
      const profile = await getMe(role);
      setSession({ token: accessToken, role, profile });
      return { role };
    },
    onSuccess: (result) => {
      router.replace(result.role === "agent" ? "/agent" : "/user");
    },
  });

  const isDisabled = useMemo(
    () => !email.trim() || !password.trim() || mutation.isPending,
    [email, password, mutation.isPending]
  );

  return (
    <div className="w-full max-w-md rounded-2xl border border-[#E2E0DD] bg-white p-6 shadow-[0_16px_45px_rgba(0,0,0,0.06)]">
      <AuthBranding subtitle="Please fill this form with your login credentials" />

      <h2 className="mb-3 text-2xl font-extrabold text-[#2C2C2C]">Login</h2>
      <div className="grid grid-cols-2 gap-2 rounded-xl bg-[#F8ECE5] p-1">
        <button
          type="button"
          onClick={() => setRole("user")}
          className={`rounded-lg px-3 py-2 text-sm font-medium transition ${
            role === "user" ? "bg-[#FBC036] text-black shadow-sm" : "text-[#514F4D]"
          }`}
        >
          User
        </button>
        <button
          type="button"
          onClick={() => setRole("agent")}
          className={`rounded-lg px-3 py-2 text-sm font-medium transition ${
            role === "agent" ? "bg-[#FBC036] text-black shadow-sm" : "text-[#514F4D]"
          }`}
        >
          Agent
        </button>
      </div>

      <form
        className="mt-4 space-y-3"
        onSubmit={(event) => {
          event.preventDefault();
          mutation.mutate();
        }}
      >
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          className="w-full rounded-[10px] border border-[#AAADB7] bg-transparent px-4 py-3 text-sm text-[#2C2C2C] outline-none focus:border-[#FBC036]"
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          className="w-full rounded-[10px] border border-[#AAADB7] bg-transparent px-4 py-3 text-sm text-[#2C2C2C] outline-none focus:border-[#FBC036]"
        />
        <div className="pt-1">
          <button type="button" className="text-sm font-medium text-[#FBC036] underline">
            Forgot Password
          </button>
        </div>
        <button
          type="submit"
          disabled={isDisabled}
          className="w-full rounded-xl bg-[#FBC036] px-4 py-3 text-sm font-semibold text-black disabled:cursor-not-allowed disabled:opacity-50"
        >
          {mutation.isPending ? "Signing in..." : `Continue as ${role}`}
        </button>
      </form>

      <div className="my-5 flex items-center gap-2">
        <div className="h-px flex-1 bg-[#E2E0DD]" />
        <span className="text-sm text-[#9D9995]">Or</span>
        <div className="h-px flex-1 bg-[#E2E0DD]" />
      </div>

      <p className="text-center text-xs font-medium text-[#2C2C2C]">
        Don&apos;t have an account?{" "}
        <Link href="/register" className="text-[#FBC036] underline">
          Signup
        </Link>
      </p>

      {mutation.isError && (
        <p className="mt-3 text-sm text-red-600">
          {(mutation.error as Error).message || "Login failed. Please verify credentials."}
        </p>
      )}
    </div>
  );
}
