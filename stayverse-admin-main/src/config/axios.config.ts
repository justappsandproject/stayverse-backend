import axios from "axios";
import useAuthStore from "@/stores/auth.store";
import { toast } from "sonner";

const BASE_URL_STAGING = import.meta.env.VITE_API_URL || 'https://api.stayversepro.com/';

export const API_URL = BASE_URL_STAGING;

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
