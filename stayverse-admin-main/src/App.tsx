import React from "react";
import { createBrowserRouter, Outlet, RouterProvider } from "react-router-dom";
import GuestGuard from "./pages/layouts/GuestGuard";
import SigninPage from "./pages/signin";
import { Toaster } from "./components/ui/sonner";
import AuthGuard from "./pages/layouts/AuthGuard";
import DashboardLayout from "./pages/layouts/DashboardLayout";
import Dashboard from "./pages/dashboard";
import ManageHosts from "./pages/manage-hosts";
import ManageChefs from "./pages/manage-chefs";
import ManageListings from "./pages/manage-listings";
import Bookings from "./pages/bookings";
import Transactions from "./pages/transactions";
import EscrowsPage from "./pages/escrows";
import HostDetails from "./pages/host-details";
import BookingDetails from "./pages/booking-details";
import CuratedMessagesPage from "./pages/curated-messages";

const router = createBrowserRouter([
  {
    path: "auth/login",
    element: (
      <GuestGuard>
        <SigninPage />
      </GuestGuard>
    ),
  },
  {
    path: "/",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        index: true,
        element: <Dashboard />,
      },
      {
        path: "listings",
        element: <ManageListings />,
      },
      {
        path: "hosts",
        element: <Outlet />,
        children: [
          { index: true, element: <ManageHosts /> },
          { path: ":agentId/:serviceType", element: <HostDetails /> },
        ],
      },
      {
        path: "chefs",
        element: <ManageChefs />,
      },
      {
        path: "bookings",
        element: <Outlet />,
        children: [
          { index: true, element: <Bookings /> },
          { path: ":bookingId", element: <BookingDetails /> },
        ],
      },
      {
        path: "transactions",
        element: <Transactions />,
      },
      {
        path: "escrows",
        element: <EscrowsPage />,
      },
      {
        path: "curated-messages",
        element: <CuratedMessagesPage />,
      },
      {
        path: "*",
        element: (
          <div className="flex items-center justify-center w-full h-screen font-bold text-7xl">
            404 🤡
          </div>
        ),
      },
    ],
  },
]);

export default function App() {
  return (
    <React.Fragment>
      <RouterProvider router={router} />
      <Toaster richColors />
    </React.Fragment>
  );
}
