import axios from "axios";
import useAuthStore from "@/stores/auth.store";
import { toast } from "sonner";

const FALLBACK_API_URL = "https://stayverse-backend-lzlu.onrender.com/";
const ENV_API_URL = import.meta.env.VITE_API_URL;
const IS_PROD = import.meta.env.PROD;

// Guard against broken production deployments where VITE_API_URL is set to localhost.
export const API_URL =
  !ENV_API_URL || (IS_PROD && ENV_API_URL.includes("localhost"))
    ? FALLBACK_API_URL
    : ENV_API_URL;

export const axiosInstance = axios.create({
    baseURL: API_URL,
    validateStatus: (status) => status < 500,
});

axiosInstance.interceptors.request.use(
    (config) => {
        const token = useAuthStore.getState().token;
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

axiosInstance.interceptors.response.use(
    (response) => {
        if (response.status === 401 && useAuthStore.getState().isAuthenticated) {
            toast.warning('Authentication has expired. Please login again.');
            useAuthStore.getState().logout();
        }
        return response;
    },
    (error) => Promise.reject(error)
);
