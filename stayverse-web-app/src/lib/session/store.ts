"use client";

import { create } from "zustand";
import { STORAGE_KEY } from "@/lib/config";
import { setApiToken } from "@/lib/api/http";
import type { AppRole, SessionUser } from "@/lib/types";

type SessionState = {
  token: string | null;
  role: AppRole | null;
  profile: SessionUser | null;
  hydrated: boolean;
  hydrate: () => void;
  setSession: (input: { token: string; role: AppRole; profile: SessionUser | null }) => void;
  clearSession: () => void;
};

function readPersisted() {
  if (typeof window === "undefined") return null;
  const raw = window.localStorage.getItem(STORAGE_KEY);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as { token: string; role: AppRole; profile: SessionUser | null };
  } catch {
    return null;
  }
}

export const useSessionStore = create<SessionState>((set) => ({
  token: null,
  role: null,
  profile: null,
  hydrated: false,
  hydrate: () => {
    const saved = readPersisted();
    if (saved?.token && saved.role) {
      setApiToken(saved.token);
      set({ ...saved, hydrated: true });
      return;
    }
    set({ hydrated: true });
  },
  setSession: ({ token, role, profile }) => {
    setApiToken(token);
    if (typeof window !== "undefined") {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify({ token, role, profile }));
    }
    set({ token, role, profile });
  },
  clearSession: () => {
    setApiToken(null);
    if (typeof window !== "undefined") {
      window.localStorage.removeItem(STORAGE_KEY);
    }
    set({ token: null, role: null, profile: null });
  },
}));
