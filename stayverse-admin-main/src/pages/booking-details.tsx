import { NavLink } from "react-router-dom";
import { SquareChevronLeft } from "lucide-react";
import { useParams } from "react-router-dom";
import {
    APIProvider,
    Map,
    Marker,
} from "@vis.gl/react-google-maps";
import { useEffect, useState, useMemo } from "react";
import { Booking } from "@/types/booking";
import { BookingService } from "@/api/booking-service";
import { adaptBookingForDisplay } from "@/lib/booking-adapter";

const mapCenter = {
    lng: 3.599731,
    lat: 6.500881,
};

export default function BookingDetails() {
    const { bookingId } = useParams<{ bookingId: string }>();

    const [booking, setBooking] = useState<Booking | null>(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (!bookingId) return;
        setLoading(true);
        BookingService.getBookingById(bookingId)
            .then((response) => {
                setBooking(response.data[0]);
            })
            .finally(() => {
                setLoading(false);
            });
    }, [bookingId]);

    // Memoize the adapted booking data to avoid recalculation on every render
    const displayData = useMemo(() => {
        return booking ? adaptBookingForDisplay(booking) : null;
    }, [booking]);

    if (loading) {
        return (
            <div className="px-10 pb-12 pt-[30px] flex justify-center items-center min-h-[60vh]">
                <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
            </div>
        );
    }

    if (!booking || !displayData) return null;

    return (
        <section className="px-10 pb-12 pt-[30px] _space-y-10">
            <NavLink to={"/bookings"} className="">
                <SquareChevronLeft size={32} strokeWidth={0.8} />
            </NavLink>

            {/* Map Container */}
            <div className="w-full h-[530px] mt-10 rounded-2xl overflow-hidden">
                <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
                    <Map
                        defaultCenter={displayData.location || mapCenter}
                        defaultZoom={15}
                        gestureHandling="greedy"
                        disableDefaultUI={true}
                        mapId={""}
                    >
                        {displayData.location && (
                            <Marker
                                position={displayData.location}
                                icon={{
                                    url: "/images/pickup-marker.svg",
                                }}
                            />
                        )}
                    </Map>
                </APIProvider>
            </div>

            {/* Booking Details */}
            <div className="mt-6 mb-10 space-y-5">
                <div className="w-fit px-7 py-[7px] font-medium text-white bg-primary rounded-lg">
                    Order details
                </div>

                <div className="w-full h-fit min-h-[115px] bg-light px-6 py-5 rounded-lg grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                    <div className="col-start gap-1">
                        <span className="text-[#50555C]">Order ID</span>
                        <span className="w-full font-bold text-black truncate">
                            #{displayData.orderId}
                        </span>
                    </div>
                    <div className="col-start gap-1">
                        <span className="text-[#50555C]">Fee</span>
                        <span className="font-bold text-black">
                            {displayData.fee}
                        </span>
                    </div>
                    <div className="col-start gap-1">
                        <span className="text-[#50555C]">Address</span>
                        <span className="font-bold text-black">
                            {displayData.address}
                        </span>
                    </div>
                    <div className="col-start gap-1">
                        <span className="text-[#50555C]">Date</span>
                        <span className="font-bold text-black">
                            {displayData.date}
                        </span>
                    </div>
                </div>

                {/* Additional Booking Information */}
                <div className="w-full grid grid-cols-1 md:grid-cols-2 gap-5 mt-8">
                    {/* Service Information */}
                    <div className="bg-light rounded-lg p-6">
                        <h3 className="font-semibold text-lg mb-4">
                            {displayData.serviceType} Information
                        </h3>

                        <div className="space-y-4">
                            <div>
                                <p className="text-sm text-gray-500">Service Name</p>
                                <p className="font-medium">{displayData.serviceName}</p>
                            </div>

                            <div>
                                <p className="text-sm text-gray-500">Location</p>
                                <p className="font-medium">{displayData.address}</p>
                            </div>

                            <div className="grid grid-cols-2 gap-4 mt-6">
                                {displayData.serviceDetails.map((detail, index) => (
                                    <div key={index}>
                                        <p className="text-sm text-gray-500">{detail.label}</p>
                                        <p className="font-medium">{detail.value}</p>
                                    </div>
                                ))}
                            </div>

                            <div className="mt-4">
                                <p className="text-sm text-gray-500">Status</p>
                                <p className="font-medium capitalize">{booking.status}</p>
                            </div>
                        </div>
                    </div>

                    {/* Agent Information */}
                    {displayData.agentInfo ? (
                        <div className="bg-light rounded-lg p-6">
                            <h3 className="font-semibold text-lg mb-4">Agent Information</h3>

                            <div className="flex items-center mb-4">
                                {displayData.agentInfo.profilePicture ? (
                                    <div className="w-12 h-12 rounded-full overflow-hidden mr-4">
                                        <img
                                            src={displayData.agentInfo.profilePicture}
                                            alt="Agent"
                                            className="w-full h-full object-cover"
                                        />
                                    </div>
                                ) : (
                                    <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center mr-4">
                                        <span className="text-primary font-semibold text-lg">
                                            {displayData.agentInfo.name.charAt(0)}
                                        </span>
                                    </div>
                                )}
                                <div>
                                    <p className="font-medium">{displayData.agentInfo.name}</p>
                                    <p className="text-sm text-gray-500">{displayData.agentInfo.email}</p>
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-4 mt-4">
                                <div>
                                    <p className="text-sm text-gray-500">Phone</p>
                                    <p className="font-medium">{displayData.agentInfo.phone}</p>
                                </div>
                                <div>
                                    <p className="text-sm text-gray-500">Service Type</p>
                                    <p className="font-medium capitalize">{displayData.serviceType}</p>
                                </div>
                            </div>

                            <div className="mt-6 pt-4 border-t border-gray-200">
                                <h4 className="font-medium mb-3">Customer Information</h4>
                                <div className="space-y-2">
                                    <div>
                                        <p className="text-sm text-gray-500">Name</p>
                                        <p className="font-medium">{displayData.userInfo.name}</p>
                                    </div>
                                    <div className="grid grid-cols-2 gap-4">
                                        <div>
                                            <p className="text-sm text-gray-500">Phone</p>
                                            <p className="font-medium">{displayData.userInfo.phone}</p>
                                        </div>
                                        <div>
                                            <p className="text-sm text-gray-500">Email</p>
                                            <p className="font-medium text-sm">{displayData.userInfo.email}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    ) : (
                        <div className="bg-light rounded-lg p-6">
                            <h3 className="font-semibold text-lg mb-4">Agent Information</h3>
                            <div className="text-center mt-20">
                                <h2 className="text-2xl font-bold">No agent assigned</h2>
                                <p className="mt-2">
                                    This booking does not have an assigned agent.
                                </p>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </section>
    );
}