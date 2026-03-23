import { Outlet } from "react-router-dom";



export default function AuthLayout() {
    return (
        <div className="w-full p-0 m-0 grid grid-cols-1 md:grid-cols-2 min-h-screen ">
            <div className="hidden md:block md:col-span-1 md:h-screen relative bg-black">
                <div className="px-[30px] py-[59px] flex justify-between items-center gap-5">
                    <img className="max-w-[224px]" src="/images/flex2ride-full-logo.png" alt="Flex2ride full logo" />
                    <span className="font-semibold text-xl text-white">SuperAdmin</span>
                </div>
                <img className="absolute inset-x-0 top-0 m-auto" src="/images/flex2ride-wavy-dots.png" alt="Flex2ride wavy dots" />
                <img className="absolute bottom-0 left-0" src="/images/flex2ride-suv.png" alt="Flex2ride SUV" />
                {/* <img className="w-full h-full object-cover" src="/images/auth-image.png" alt="Beautiful background image" /> */}
            </div>
            <div className="col-span-2 md:col-span-1">
                <Outlet />
            </div>
        </div>
    )
}
