import { Booking } from "@/types/booking";

export interface BookingDisplayData {
    orderId: string;
    fee: string;
    address: string;
    date: string;
    serviceType: string;
    serviceName: string;
    location: {
        lat: number;
        lng: number;
    } | null;
    agentInfo: {
        name: string;
        phone: string;
        email: string;
        profilePicture?: string;
    } | null;
    serviceDetails: {
        label: string;
        value: string;
    }[];
    userInfo: {
        name: string;
        phone: string;
        email: string;
    };
}

/**
 * Adapts booking data to a normalized display format
 * Eliminates the need for conditional rendering throughout the component
 */
export function adaptBookingForDisplay(booking: Booking): BookingDisplayData {
    const { serviceType, apartment, ride, chef, agent, user } = booking;

    // Base data common to all booking types
    const baseData = {
        orderId: booking._id,
        fee: `N${(+booking.totalPrice.toFixed(2)).toLocaleString()}`,
        date: new Date(booking.createdAt).toLocaleDateString('en-US', {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        }),
        userInfo: {
            name: `${user.firstname} ${user.lastname}`,
            phone: user.phoneNumber,
            email: user.email,
        },
        agentInfo: agent ? {
            name: `${agent.user.firstname} ${agent.user.lastname}`,
            phone: agent.user.phoneNumber,
            email: agent.user.email,
            profilePicture: agent.user.profilePicture,
        } : null,
    };

    // Service-specific data
    switch (serviceType) {
        case 'apartment':
            return {
                ...baseData,
                serviceType: 'Apartment',
                serviceName: apartment?.apartmentName || 'N/A',
                address: apartment?.address || 'N/A',
                location: apartment?.location ? {
                    lat: apartment.location.coordinates[1],
                    lng: apartment.location.coordinates[0],
                } : null,
                serviceDetails: [
                    { label: 'Type', value: apartment?.apartmentType || 'N/A' },
                    { label: 'Bedrooms', value: apartment?.numberOfBedrooms?.toString() || 'N/A' },
                    { label: 'Max Guests', value: apartment?.maxGuests?.toString() || 'N/A' },
                    { label: 'Check-in', value: new Date(booking.startDate).toLocaleDateString() },
                    { label: 'Check-out', value: new Date(booking.endDate).toLocaleDateString() },
                    { label: 'Price/Night', value: `N${apartment?.pricePerDay?.toLocaleString() || 'N/A'}` },
                ],
            };

        case 'ride':
            return {
                ...baseData,
                serviceType: 'Ride',
                serviceName: ride?.rideName || 'N/A',
                address: ride?.address || 'N/A',
                location: ride?.location ? {
                    lat: ride.location.coordinates[1],
                    lng: ride.location.coordinates[0],
                } : null,
                serviceDetails: [
                    { label: 'Type', value: ride?.rideType || 'N/A' },
                    { label: 'Plate Number', value: ride?.plateNumber || 'N/A' },
                    { label: 'Color', value: ride?.color || 'N/A' },
                    { label: 'Max Passengers', value: ride?.maxPassengers?.toString() || 'N/A' },
                    { label: 'Start Date', value: new Date(booking.startDate).toLocaleDateString() },
                    { label: 'End Date', value: new Date(booking.endDate).toLocaleDateString() },
                    { label: 'Price/Day', value: `N${ride?.pricePerDay?.toLocaleString() || 'N/A'}` },
                ],
            };

        case 'chef':
            return {
                ...baseData,
                serviceType: 'Chef',
                serviceName: chef?.fullName || 'N/A',
                address: chef?.address || 'N/A',
                location: chef?.location ? {
                    lat: chef.location.coordinates[1],
                    lng: chef.location.coordinates[0],
                } : null,
                serviceDetails: [
                    { label: 'Specialties', value: chef?.culinarySpecialties?.join(', ') || 'N/A' },
                    { label: 'Experience', value: chef?.hasExperience ? 'Yes' : 'No' },
                    { label: 'Certified', value: chef?.hasCertifications ? 'Yes' : 'No' },
                    { label: 'Start Date', value: new Date(booking.startDate).toLocaleDateString() },
                    { label: 'End Date', value: new Date(booking.endDate).toLocaleDateString() },
                    { label: 'Price/Hour', value: `N${chef?.pricingPerHour?.toLocaleString() || 'N/A'}` },
                ],
            };

        default:
            // Fallback for unknown service types
            return {
                ...baseData,
                serviceType: 'Unknown',
                serviceName: 'N/A',
                address: 'N/A',
                location: null,
                serviceDetails: [],
            };
    }
}
