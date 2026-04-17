export type AppRole = "user" | "agent";

export interface LoginPayload {
  email: string;
  password: string;
}

export interface SessionUser {
  _id?: string;
  id?: string;
  firstname?: string;
  lastname?: string;
  email?: string;
  role?: string;
  phoneNumber?: string;
  kycStatus?: string;
  profilePicture?: string;
  balance?: number;
  agent?: {
    _id?: string;
    serviceType?: string;
  };
}

export interface LoginResponse {
  accessToken?: string;
  access_token?: string;
  user?: SessionUser;
  agent?: SessionUser;
  isEmailVerified?: boolean;
}

export interface PaginatedResponse<T> {
  data?: T[];
  docs?: T[];
  items?: T[];
  total?: number;
  page?: number;
  limit?: number;
}

export interface ServiceListing {
  _id: string;
  title?: string;
  name?: string;
  address?: string;
  location?: string | { type?: string; coordinates?: number[] };
  status?: string;
  createdAt?: string;
  price?: number;
}

export interface ChefListing {
  _id: string;
  fullName?: string;
  address?: string;
  status?: string;
  pricingPerHour?: number;
}

export interface BookingRecord {
  _id: string;
  serviceType?: "apartment" | "ride";
  status?: string;
  createdAt?: string;
  totalAmount?: number;
}

export interface WalletTransaction {
  _id: string;
  reference?: string;
  amount?: number;
  type?: "credit" | "debit";
  status?: string;
  description?: string;
  createdAt?: string;
}

export interface FavoriteRecord {
  _id: string;
  serviceType?: "apartment" | "ride" | "chef";
  createdAt?: string;
  apartment?: ServiceListing;
  ride?: ServiceListing;
  chef?: {
    _id: string;
    firstname?: string;
    lastname?: string;
  };
}

export interface CuratedMessage {
  _id?: string;
  id?: string;
  audience?: "user" | "agent" | "all";
  title: string;
  body: string;
  createdAt?: string;
}
