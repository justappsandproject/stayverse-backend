import useAuthStore from '@/stores/auth.store';
import type { ReactNode } from 'react';
import { Navigate } from 'react-router-dom';
// import useAuthStore from '../stores/authStore';

interface GuestGuardProps {
    children: ReactNode;
}

function GuestGuard ({ children }: GuestGuardProps) {
    const { isAuthenticated } = useAuthStore();

    if (isAuthenticated) {
        return <Navigate to='/' />;
    }

    return <>{children}</>;
}

export default GuestGuard;