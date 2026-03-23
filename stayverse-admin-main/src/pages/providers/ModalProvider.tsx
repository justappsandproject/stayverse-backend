import { ChefProfileModal } from "@/components/chefs/chef-profile-modal";
import { UserProfileModal } from "@/components/dashboard/user-profile-modal";
import ApartmentDetailsModal from "@/components/hosts/apartment-details-modal";
import RideDetailsModal from "@/components/hosts/ride-details-modal";


export default function ModalProvider() {

    return (
        <>
            <UserProfileModal />
            <ChefProfileModal />
            <ApartmentDetailsModal />
            <RideDetailsModal />
        </>
    )
}