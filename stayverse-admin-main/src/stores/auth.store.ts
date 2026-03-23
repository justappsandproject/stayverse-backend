import { axiosInstance } from "@/config/axios.config";
import { AuthService } from "@/api/auth-service";
import { Admin } from "@/types/admin";
import { create } from "zustand";
import { persist, devtools, createJSONStorage } from "zustand/middleware";


type AuthState = {
    isAuthenticated: boolean;
    token: string | null;
    admin: Admin | null;
    setIsAuthenticated: (isAuthenticated: boolean) => void;
    setToken: (token: string | null) => void;
    setAdmin: (admin: Admin | null) => void;
    login: (email: string, password: string) => Promise<void>;
    logout: () => void;
}

const useAuthStore = create<AuthState>()(
    devtools(
        persist(
            (set) => ({
                isAuthenticated: false,
                token: null,
                admin: null,
                
                setIsAuthenticated: (isAuthenticated: boolean) => {
                    set({ isAuthenticated });
                },
                
                setToken: (token: string | null) => {
                    set({ token });
                    if (token) {
                        axiosInstance.defaults.headers.common['Authorization'] = `Bearer ${token}`;
                    } else {
                        delete axiosInstance.defaults.headers.common['Authorization'];
                    }
                },
                
                setAdmin: (admin: Admin | null) => set({ admin }),
                
                login: async (email: string, password: string) => {
                    const result = await AuthService.login(email, password);
                    if (result) {
                        set({
                            isAuthenticated: true,
                            token: result.access_token,
                            admin: result?.user
                        });
                        useAuthStore.getState().setToken(result?.access_token);
                    }
                },
                
                logout: () => {
                    set({
                        isAuthenticated: false,
                        token: null,
                        admin: null
                    });
                    useAuthStore.getState().setToken(null);
                },
            }),
            {
                name: "stayverse-superadmin_auth-storage",
                storage: createJSONStorage(() => localStorage),
            }
        )
    )
);

export default useAuthStore;
