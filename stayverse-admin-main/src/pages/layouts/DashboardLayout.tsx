import { Separator } from "@/components/ui/separator";
import { Sidebar, SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";
import useAuthStore from "@/stores/auth.store";
import {
  Calendar,
  ChefHat,
  HandCoins,
  LayoutDashboard,
  LayoutGrid,
  List,
  LogOut,
  Megaphone,
  MessageSquareText,
  SearchIcon,
  ShieldCheck,
} from "lucide-react";
import { NavLink, Outlet } from "react-router-dom";
import ModalProvider from "../providers/ModalProvider";

export default function DashboardLayout() {
  const { setIsAuthenticated } = useAuthStore();

  const navLinks = [
    { name: "Dashboard", path: "/", icon: LayoutDashboard },
    { name: "Manage Listings", path: "/listings", icon: LayoutGrid },
    { name: "Manage Hosts", path: "/hosts", icon: List },
    { name: "Manage Chefs", path: "/chefs", icon: ChefHat },
    { name: "Bookings", path: "/bookings", icon: Calendar },
    { name: "Transactions", path: "/transactions", icon: HandCoins },
    { name: "Escrows", path: "/escrows", icon: ShieldCheck },
    { name: "Curated Messages", path: "/curated-messages", icon: Megaphone },
  ];

  return (
    <>
      <ModalProvider />
      <SidebarProvider>
        <Sidebar className="h-full bg-dark text-white">
          <div className="bg-dark h-full flex flex-col">
            <div className="px-5 pt-6 pb-5 border-b border-white/10">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-xl bg-primary-500 text-dark center font-bold">
                  S
                </div>
                <div>
                  <p className="text-base font-semibold leading-tight">Stayverse Admin</p>
                  <p className="text-xs text-white/60">Control Center</p>
                </div>
              </div>
            </div>

            <div className="flex-1 overflow-y-auto py-4 px-3 no-scrollbar">
              <div className="text-[11px] uppercase tracking-[0.12em] text-white/40 px-3 pb-3">
                Navigation
              </div>
              {navLinks.map((link, index) => (
                <NavLink
                  key={index}
                  to={link.path}
                  className={({ isActive }) =>
                    cn(
                      "group/nav-item w-full min-h-[46px] rounded-xl mb-1.5 flex items-center gap-3 px-3 transition-all duration-200",
                      isActive
                        ? "bg-white text-dark shadow-sm"
                        : "text-white/80 hover:text-white hover:bg-white/10",
                    )
                  }
                >
                  <link.icon size={18} />
                  <span className="text-[15px] font-medium">{link.name}</span>
                </NavLink>
              ))}
            </div>

            <div className="px-3 py-3 border-t border-white/10">
              <div className="rounded-xl bg-white/5 p-3 mb-2 flex items-start gap-2.5">
                <MessageSquareText size={16} className="text-primary-500 mt-0.5" />
                <p className="text-xs text-white/75 leading-5">
                  Need help? Reach out to engineering support for urgent admin issues.
                </p>
              </div>
              <Button
                variant="ghost"
                className="w-full justify-start text-white/80 hover:text-dark hover:bg-white"
                onClick={() => setIsAuthenticated(false)}
              >
                <LogOut size={16} />
                Logout
              </Button>
            </div>
          </div>
        </Sidebar>

        <div className="w-full max-h-svh flex-grow col-start overflow-x-hidden overflow-y-auto bg-gradient-to-br from-[#f5f6f8] via-[#f1f3f7] to-[#eceff4]">
          <div className="w-full min-h-[84px] bg-white/75 backdrop-blur-md border-b border-black/5 flex items-center gap-3 sm:gap-4 px-4 sm:px-6 lg:px-8 sticky top-0 z-20">
            <SidebarTrigger className="md:hidden" />
            <div className="hidden md:flex">
              <SidebarTrigger />
            </div>
            <div className="w-full max-w-[500px] relative">
              <SearchIcon
                size={18}
                className="absolute left-3 top-1/2 -translate-y-1/2 text-black/40"
              />
              <Input
                type="text"
                className="h-10 pl-9 bg-white border-black/10"
                placeholder="Search bookings, users, transactions..."
              />
            </div>
            <div className="ml-auto text-right hidden sm:block">
              <p className="text-xs text-black/50">Welcome back</p>
              <p className="text-sm font-semibold text-black/80">Admin</p>
            </div>
          </div>
          <Separator orientation="horizontal" />
          <div className="w-full flex-grow animate-fade-in">
            <Outlet />
          </div>
        </div>
      </SidebarProvider>
    </>
  );
}
