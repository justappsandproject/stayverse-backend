import { axiosInstance } from "@/config/axios.config";
import { toast } from "sonner";


interface FetchDataParams {
    url: string;
    params?: Record<string, any>;
    failedMessage?: string;
    fallback?: any;
}

export interface PaginatedResponse<T, Metadata = any> {
    data: T;
    pagination: {
        totalItems: number;
        totalPages: number;
        currentPage: number;
        pageSize: number;
        hasNextPage: boolean;
        hasPreviousPage: boolean;
    };
    metadata?: Metadata
}

export const fetchData = async <T = Record<string, any>[]>({
    url,
    params = {},
    failedMessage = 'Request failed.',
    fallback = []
}: FetchDataParams): Promise<T> => {
    try {
        const { data, status } = await axiosInstance.get(url, { params });
        if (status === 200) {
            return data?.data as T || fallback;
        }
        toast.warning(data?.message || failedMessage);
        return fallback;
    } catch (error: any) {
        console.error(`${url} error ->`, error.message);
        toast.error(failedMessage);
        return fallback;
    }
};


export const fetchPaginatedData = async <T = Record<string, any>[], Metadata = Record<string, any>>({
    url,
    params = {},
    failedMessage = 'Request failed.',
    fallback = { data: [], pagination: { totalItems: 0, totalPages: 0, currentPage: 1, pageSize: 10, hasNextPage: false, hasPreviousPage: false } }
}: FetchDataParams): Promise<PaginatedResponse<T, Metadata>> => {
    try {
        const { data, status } = await axiosInstance.get(url, { params });
        if (status === 200) {
            return data?.data || fallback;
        }
        toast.warning(data?.message || failedMessage);
        return fallback;
    } catch (error: any) {
        console.error(`${url} error ->`, error.message);
        toast.error(failedMessage);
        return fallback;
    }
};

export default fetchData;
