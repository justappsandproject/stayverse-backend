import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";

export interface LoginResponse {
    access_token: string
    isEmailVerified: boolean
    user: {
        _id: string
        firstname: string
        lastname: string
        email: string
        phoneNumber: string
        isEmailVerified: boolean
        role: string
        createdAt: string
        updatedAt: string
        __v: number
    }
}

export const AuthService = {
    login: async (email: string, password: string) => {
        try {
            const { data, status } = await axiosInstance.post('/users/login', { email, password, expectedRole: 'admin' });
            if (status === 200) {
                toast.success('Login successful.');
                return data?.data as LoginResponse;
            } else {
                toast.warning(data?.message);
            }
        } catch {
            toast.error('Login failed! Please try again');
        }
    }
}