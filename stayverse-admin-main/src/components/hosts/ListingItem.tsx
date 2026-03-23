import useModalStore from "@/stores/modal.store"
import StarRating from "../StarRating"
import { Button } from "../ui/button";


interface ListingItemProps {
    serviceType: string;
    _id: string;
    photo: string;
    name: string;
    location: string;
    rating: number;
    status: string;
    metadata: any;
}
export default function HostListingItem({ photo, name, location, rating, status, serviceType, metadata }: ListingItemProps) {
    const { setOpen: openApartmentDetailsModal } = useModalStore().apartmentDetails;
    const { setOpen: openRideDetailsModal } = useModalStore().rideDetails;

    function openDetailsModal() {
        if (serviceType === 'apartment') {
            openApartmentDetailsModal(true, metadata);
        } else if (serviceType === 'ride') {
            openRideDetailsModal(true, metadata);
        }
    }

    return (
        <div className="w-full min-w-fit group  bg-[#EBEBEB] rounded-lg">
            <div className="w-full px-5 py-[18px] flex justify-between items-center gap-5 md:gap-10">
                <div className="cursor-pointer">
                    {photo ? (
                        <img src={photo} alt={name} className="w-[59px] h-[59px] rounded-full object-cover " />
                    ) : (
                        <div className="w-[56px] h-[56px] bg-gradient-to-b from-dark to-secondary rounded-full flex items-center justify-center">
                            <span className="text-white text-[20px] font-bold">{name.slice(0, 2)}</span>
                        </div>
                    )}
                </div>
                <div className="w-full grid flex-1 grid-cols-4 gap-3 lg:gap-5">
                    <div className="flex flex-col min-w-0 gap-1">
                        <span className="text-[#646464] text-[15px]">Name</span>
                        <span className="text-black text-base xl:text-[18px] font-medium truncate">{name} </span>
                    </div>
                    <div className="flex flex-col min-w-0 gap-1">
                        <span className="text-[#646464] text-[15px]">Location</span>
                        <span className="text-black text-base xl:text-[18px] font-medium truncate">{location}</span>
                    </div>
                    <div className="flex flex-col min-w-0 gap-1">
                        <span className="text-[#646464] text-[15px]">Status</span>
                        <span className="text-black text-base xl:text-[18px] font-medium truncate">{status}</span>
                    </div>
                    <div className="flex flex-col min-w-0 gap-1">
                        <span className="text-[#646464] text-[15px]">Rating</span>
                        <StarRating rating={rating} size={24} />
                    </div>
                </div>
                <Button size={'lg'} className="ml-auto xl:ml-20 px-4 text-white/90 text-sm font-medium cursor-pointer" onClick={() => openDetailsModal()}>
                    View
                </Button>
                {/* <label htmlFor={`toggle-${_id}`} className="ml-auto px-4 text-[#646464] text-lg font-medium cursor-pointer">
                    <ChevronRight size={28} stroke="black" strokeWidth={1} className="transition-transform ease-out group-has-[:checked]:rotate-90" />
                </label> */}
                {/* <input type="checkbox" id={`toggle-${chef._id}`} hidden /> */}
            </div>
        </div>
    )
}