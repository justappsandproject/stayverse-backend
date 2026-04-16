"use client";

import Link from "next/link";
import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { registerByRole } from "@/lib/api/auth";
import type { AppRole } from "@/lib/types";
import { AuthBranding } from "@/components/auth/branding";

type FormState = {
  firstname: string;
  lastname: string;
  email: string;
  phoneNumber: string;
  password: string;
  confirmPassword: string;
  serviceType: "apartment" | "ride";
};

const inputClass =
  "w-full rounded-[10px] border border-[#AAADB7] bg-transparent px-4 py-3 text-sm text-[#2C2C2C] outline-none transition focus:border-[#FBC036]";

export function RegisterForm() {
  const [role, setRole] = useState<AppRole>("user");
  const [form, setForm] = useState<FormState>({
    firstname: "",
    lastname: "",
    email: "",
    phoneNumber: "",
    password: "",
    confirmPassword: "",
    serviceType: "apartment",
  });

  const mutation = useMutation({
    mutationFn: async () => {
      if (form.password !== form.confirmPassword) {
        throw new Error("Password and confirm password do not match.");
      }
      if (role === "user") {
        return registerByRole(role, {
          firstname: form.firstname,
          lastname: form.lastname,
          email: form.email,
          phoneNumber: form.phoneNumber,
          password: form.password,
        });
      }
      return registerByRole(role, {
        firstname: form.firstname,
        lastname: form.lastname,
        email: form.email,
        phoneNumber: form.phoneNumber,
        password: form.password,
        serviceType: form.serviceType,
      });
    },
  });

  return (
    <div className="w-full max-w-md rounded-2xl border border-[#E2E0DD] bg-white p-6 shadow-[0_16px_45px_rgba(0,0,0,0.06)]">
      <AuthBranding subtitle="Please fill in this form to create an account" />

      <div className="mb-4 grid grid-cols-2 gap-2 rounded-xl bg-[#F8ECE5] p-1">
        <button
          type="button"
          onClick={() => setRole("user")}
          className={`rounded-lg px-3 py-2 text-sm font-medium ${
            role === "user" ? "bg-[#FBC036] text-black" : "text-[#514F4D]"
          }`}
        >
          User
        </button>
        <button
          type="button"
          onClick={() => setRole("agent")}
          className={`rounded-lg px-3 py-2 text-sm font-medium ${
            role === "agent" ? "bg-[#FBC036] text-black" : "text-[#514F4D]"
          }`}
        >
          Agent
        </button>
      </div>

      <form
        className="space-y-3"
        onSubmit={(event) => {
          event.preventDefault();
          mutation.mutate();
        }}
      >
        <div className="grid grid-cols-2 gap-3">
          <input
            className={inputClass}
            placeholder="First Name"
            value={form.firstname}
            onChange={(event) => setForm((prev) => ({ ...prev, firstname: event.target.value }))}
          />
          <input
            className={inputClass}
            placeholder="Last Name"
            value={form.lastname}
            onChange={(event) => setForm((prev) => ({ ...prev, lastname: event.target.value }))}
          />
        </div>
        <input
          className={inputClass}
          type="email"
          placeholder="Email Address"
          value={form.email}
          onChange={(event) => setForm((prev) => ({ ...prev, email: event.target.value }))}
        />
        <input
          className={inputClass}
          placeholder="Phone Number"
          value={form.phoneNumber}
          onChange={(event) => setForm((prev) => ({ ...prev, phoneNumber: event.target.value }))}
        />
        {role === "agent" && (
          <select
            className={inputClass}
            value={form.serviceType}
            onChange={(event) =>
              setForm((prev) => ({
                ...prev,
                serviceType: event.target.value as "apartment" | "ride",
              }))
            }
          >
            <option value="apartment">Apartment Agent</option>
            <option value="ride">Ride Agent</option>
          </select>
        )}
        <input
          className={inputClass}
          type="password"
          placeholder="Create Password"
          value={form.password}
          onChange={(event) => setForm((prev) => ({ ...prev, password: event.target.value }))}
        />
        <input
          className={inputClass}
          type="password"
          placeholder="Confirm Password"
          value={form.confirmPassword}
          onChange={(event) =>
            setForm((prev) => ({ ...prev, confirmPassword: event.target.value }))
          }
        />

        <button
          type="submit"
          disabled={mutation.isPending}
          className="w-full rounded-xl bg-[#FBC036] px-4 py-3 text-sm font-semibold text-black disabled:opacity-60"
        >
          {mutation.isPending ? "Creating account..." : "Create Account"}
        </button>
      </form>

      <p className="mt-4 text-center text-xs font-medium text-[#2C2C2C]">
        Already have an account?{" "}
        <Link href="/" className="text-[#FBC036] underline">
          Login
        </Link>
      </p>

      <p className="mt-3 text-center text-xs font-medium text-[#2C2C2C]">
        By pressing Sign up securely, you agree to our{" "}
        <span className="text-[#FBC036]">Terms & Conditions</span> and{" "}
        <span className="text-[#FBC036]">Privacy Policy</span>.
      </p>

      {mutation.isSuccess && (
        <p className="mt-3 text-sm font-medium text-green-700">
          Account created successfully. You can now sign in.
        </p>
      )}
      {mutation.isError && (
        <p className="mt-3 text-sm font-medium text-red-600">
          {(mutation.error as Error).message || "Registration failed"}
        </p>
      )}
    </div>
  );
}
