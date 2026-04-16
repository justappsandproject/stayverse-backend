import { api } from "@/lib/api/http";
import type { AppRole } from "@/lib/types";

export async function updatePassword(
  role: AppRole,
  payload: { oldPassword: string; newPassword: string }
) {
  const endpoint = role === "agent" ? "/agents/update-password" : "/users/update-password";
  const response = await api.put(endpoint, payload);
  return response.data;
}

export async function updateNotificationPreference(role: AppRole, enable: boolean) {
  const endpoint =
    role === "agent" ? "/agents/notifications/device-token" : "/users/notifications/device-token";
  const response = await api.patch(endpoint, { enable });
  return response.data;
}

export async function deleteMyAccount(role: AppRole, password: string) {
  const endpoint = role === "agent" ? "/agents/me" : "/users/me";
  const response = await api.delete(endpoint, { data: { password } });
  return response.data;
}
