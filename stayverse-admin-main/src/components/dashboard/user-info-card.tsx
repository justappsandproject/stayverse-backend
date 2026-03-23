import useModalStore from "@/stores/modal.store";
import { User } from "@/types/user";


export default function UserInfoCard(
    { user }: { user: User }
) {
    const { setOpen: openUserProfileModal } = useModalStore().userProfileModal;

    return (
        <div className="w-full max-w-[365px] rounded-xl bg-light">
            <div className="p-5 w-full flex items-center justify-start gap-3 cursor-pointer" onClick={() => openUserProfileModal(true, { user })}>
                {user?.profilePicture ? (
                    <img src={user?.profilePicture} alt={user.firstname} className="w-[45px] h-[45px] object-cover rounded-full" />
                ) : (
                    <div className="w-[45px] h-[45px] bg-gradient-to-b from-dark to-secondary rounded-full flex items-center justify-center">
                        <span className="text-white text-[20px] font-bold">{user.firstname.slice(0, 2)}</span>
                    </div>
                )}
                <div className="flex flex-col">
                    <span className="text-[#858585] text-sm">Name</span>
                    <span className="text-black text-[20px] font-medium">{user.firstname} {user.lastname}</span>
                </div>
            </div>
            <hr className="border-t-[1px] border-[#DADADA] " />
            <div className="w-full p-5 space-y-5">
                <div className="w-full grid grid-cols-2 gap-3">
                    <div className="flex flex-col">
                        <span className="text-[#646464] text-[15px]">Email</span>
                        <span className="text-black text-lg truncate">{user.email}</span>
                    </div>
                    <div className="flex flex-col">
                        <span className="text-[#646464] text-[15px]">Contact</span>
                        <span className="text-black text-lg truncate">{user.phoneNumber}</span>
                    </div>
                </div>
                <button
                    className="w-full rounded-md text-dark bg-primary-500 p-3 cursor-pointer"
                    onClick={() => openUserProfileModal(true, { user })}
                >View</button>
            </div>
        </div>
    )
}
