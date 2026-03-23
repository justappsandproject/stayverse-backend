import axios from 'axios';

const BASE_URL_DEV = 'http://localhost:3030';
const BASE_URL_PROD = 'https://api.zylag.ng';

export const API_URL = (process.env.NODE_ENV === 'development') ? BASE_URL_DEV : BASE_URL_PROD;

export const axiosInstance = axios.create({
    baseURL: API_URL,
    validateStatus: function (status) {
        return status < 500
    },
});

// Add a request interceptor
axiosInstance.interceptors.request.use(
    function (config) {
        // You can modify the request config here if needed
        return config;
    },
    function (error) {
        // Handle request error
        return Promise.reject(error);
    }
);

// Add a response interceptor
axiosInstance.interceptors.response.use(
    function (response) {
        // If the status code is 401, redirect to the login page
        // if (response.status === 401) {
        //     window.location.href = '/login'; // Update this with your login page URL
        //     return response;
        // }

        // Return the response if not 401
        return response;
    },
    function (error) {
        // Handle response error
        return Promise.reject(error);
    }
);