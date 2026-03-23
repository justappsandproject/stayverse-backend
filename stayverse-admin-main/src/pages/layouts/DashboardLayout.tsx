import { Separator } from "@/components/ui/separator";
import {
  Sidebar,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar";
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
  ];

  return (
    <>
      <ModalProvider />
      <SidebarProvider>
        {/* sidebar */}
        <Sidebar className="min-w-[250px] +w-[15%] h-full pt-16 lg:pt-20 xl:pt-[100px] bg-dark text-white">
          <div className="bg-dark h-full space-y-5">
            {/* <img src={flexLogo} alt="flex corporate logo" className="h-[30px] mx-auto mb-10" /> */}
            <div className="h-[30px] mx-auto "></div>
            {navLinks.map((link, index) => (
              <NavLink
                key={index}
                to={link.path}
                className={({ isActive }) =>
                  cn(
                    "group/nav-item w-full h-[50px] flex items-center gap-3 pl-6",
                    isActive
                      ? " text-primary-500 active"
                      : "text-white hover:text-primary-500 _hover:bg-white",
                  )
                }
              >
                <link.icon size={20} />
                {/* <span className="w-6 object-contain object-center stroke-white group-hover/nav-item:stroke-dark [&>svg]:w-full group-[&.active]:text-dark group-[&.active]/nav-item:[&>svg]:stroke-dark ">{link.icon}</span> */}
                <span className="text-base ">{link.name}</span>
              </NavLink>
            ))}
            <hr className="border-t-[1px] border-[#989898] mt-10 " />
            {/* <NavLink to={'/support'}
                            className={({ isActive }) => cn(
                                'group/support w-full h-[50px] flex items-center gap-3 pl-6',
                                isActive ? 'bg-white text-dark stroke-dark active' : 'text-white/60 hover:text-dark hover:bg-white'
                            )}
                        >
                            <span className="w-6 object-contain object-center stroke-white group-hover/support:stroke-dark [&>svg]:w-full group-[&.active]:text-dark group-[&.active]/support:[&>svg]:stroke-dark "><Messages1Icon /></span>
                            <span className="text-base ">Support</span>
                        </NavLink> */}
            <div
              className={cn(
                "group/support w-full h-[50px] flex items-center gap-3 pl-6 mt-auto cursor-pointer",
                "text-white/60 hover:text-dark hover:bg-white",
              )}
              onClick={() => setIsAuthenticated(false)}
            >
              <span className="w-6 object-contain object-center stroke-white group-hover/support:stroke-dark [&>svg]:w-full group-[&.active]:text-dark group-[&.active]/support:[&>svg]:stroke-dark ">
                <LogOut />
              </span>
              <span className="text-base ">Logout</span>
            </div>
          </div>
        </Sidebar>

        {/* main area */}
        <div className="w-full max-h-svh flex-grow col-start overflow-x-hidden overflow-y-auto">
          <div className="w-full min-h-[100px] bg-[#F3F3F3] flex items-center px-10 ">
            <SidebarTrigger className="" />
            <div className="w-full max-w-[420px] rounded-lg bg-[#EBEBEB] pl-10 pr-5 py-[13px] flex gap-4">
              <input
                type="text"
                className="w-[400px] max-w-full text-lg placeholder:text-black/50 bg-inherit border-0 outline-none focus:border-b focus:outline-none"
                placeholder="Search Bookings "
              />
              <SearchIcon size={28} stroke="#00000080" strokeWidth={2} />
            </div>
          </div>
          <Separator orientation="horizontal" />
          <div className="w-full flex-grow">
            <Outlet />
          </div>
        </div>
      </SidebarProvider>
    </>
  );
}

// w-full h-screen overflow-hidden flex
