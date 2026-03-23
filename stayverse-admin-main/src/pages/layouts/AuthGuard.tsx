import useAuthStore from '@/stores/auth.store';
import type { ReactNode } from 'react';
import { useState } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
// import useAuthStore from '../stores/authStore';
// import { onAuthStateChanged } from 'firebase/auth';
// import { auth } from '../firebase';

interface AuthGuardProps {
    children: ReactNode;
}

function AuthGuard (props: AuthGuardProps) {
    const { children } = props;
    const authStore = useAuthStore();
    const location = useLocation();
    const [requestedLocation, setRequestedLocation] = useState<string | null>();

    if (!authStore.isAuthenticated) {
        if (location.pathname !== requestedLocation) {
            setRequestedLocation(location.pathname);
        }

        return <Navigate to={'/auth/login'} />;
    }

    // This is done so that in case the route changes by any chance through other
    // means between the moment of request and the render we navigate to the initially
    // requested route.
    if (requestedLocation && location.pathname !== requestedLocation) {
        setRequestedLocation(null);
        return <Navigate to={requestedLocation} />;
    }

    return <>{children}</>;
}

export default AuthGuard;