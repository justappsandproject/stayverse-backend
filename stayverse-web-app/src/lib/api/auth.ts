import { api } from "@/lib/api/http";
import type { AppRole, LoginPayload, LoginResponse, SessionUser } from "@/lib/types";
import { unwrapResponseData } from "@/lib/api/response";

export async function loginByRole(role: AppRole, payload: LoginPayload) {
  if (role === "user") {
    const response = await api.post<LoginResponse>("/users/login", {
      ...payload,
      expectedRole: "user",
    });
    return unwrapResponseData<LoginResponse>(response.data);
  }

  const response = await api.post<LoginResponse>("/agents/login", payload);
  return unwrapResponseData<LoginResponse>(response.data);
}

export async function getMe(role: AppRole) {
  if (role === "user") {
    const response = await api.get<SessionUser>("/users/me");
    return unwrapResponseData<SessionUser>(response.data);
  }
  const response = await api.get<SessionUser>("/agents/me");
  return unwrapResponseData<SessionUser>(response.data);
}

export type RegisterUserPayload = {
  firstname: string;
  lastname: string;
  email: string;
  phoneNumber: string;
  password: string;
};

export type RegisterAgentPayload = RegisterUserPayload & {
  serviceType: "apartment" | "ride";
};

export async function registerByRole(
  role: AppRole,
  payload: RegisterUserPayload | RegisterAgentPayload
) {
  if (role === "user") {
    const response = await api.post("/users/register", payload);
    return unwrapResponseData(response.data);
  }
  const response = await api.post("/agents/register", payload);
  return unwrapResponseData(response.data);
}
