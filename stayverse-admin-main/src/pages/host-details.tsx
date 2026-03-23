import HostListingItem from "@/components/hosts/ListingItem";
import { Separator } from "@/components/ui/separator";
import { useParams, NavLink } from "react-router-dom";
import { useEffect, useState } from "react";
import { AgentService } from "@/api/agent-service";
import { Apartment } from "@/types/apartment";
import { Ride } from "@/types/ride";
import { ManualPaginationControl } from "@/components/ManualPagination";
import { ArrowLeft } from "lucide-react";
import { formatCurrency } from "@/lib/format.utils";

export default function HostDetails() {
    const { agentId, serviceType } = useParams<{ agentId: string, serviceType: string }>();

    const [agentName, setAgentName] = useState('Stayverse Agent');
    const [agentLogo, setAgentLogo] = useState('');
    const [totalOrders, setTotalOrders] = useState(0);
    const [totalEarnings, setTotalEarnings] = useState(0);
    const [apartments, setApartments] = useState<Apartment[]>([]);
    const [rides, setRides] = useState<Ride[]>([]);
    const [loading, setLoading] = useState(false);
    const [pagination, setPagination] = useState<{ pageIndex: number; pageSize: number }>({
        pageIndex: 0, pageSize: 10,
    });
    const [totalPages, setTotalPages] = useState<number>(1);

    useEffect(() => {
        if (!agentId) return;
        AgentService.getAgentById(agentId)
            .then((response) => {
                const firstname = response.user?.firstname ?? 'Stayverse Agent';
                const lastname = response.user?.lastname ?? '';
                const profilePicture = response.user?.profilePicture ?? '';
                setAgentName(firstname + ' ' + lastname);
                setAgentLogo(profilePicture);
                setTotalOrders(response.completedBookings);
                setTotalEarnings(response.totalEarnings);
            })
            .catch((error) => {
                console.error('Error fetching agent:', error);
            });
    }, [agentId])

    useEffect(() => {
        if (!agentId || !serviceType) return;

        setLoading(true);
        if (serviceType === 'apartment') {
            AgentService.getAgentApartmentListing(agentId, {
                page: pagination.pageIndex + 1,
                limit: pagination.pageSize
            })
                .then((response) => {
                    setApartments(response.data);
                    setTotalPages(response.pagination.totalPages);
                })
                .finally(() => {
                    setLoading(false);
                });
        } else if (serviceType === 'ride') {
            AgentService.getAgentRideListing(agentId, {
                page: pagination.pageIndex + 1,
                limit: pagination.pageSize
            })
                .then((response) => {
                    setRides(response.data);
                    setTotalPages(response.pagination.totalPages);
                })
                .finally(() => {
                    setLoading(false);
                });
        }
    }, [agentId, serviceType, pagination.pageIndex, pagination.pageSize]);

    return (
        <section className="px-10 pb-12 pt-[30px] space-y-10 ">
            <header className="space-y-5">
                <div className="flex flex-col mb-10 gap-9 mt-7">
                    <div className="flex items-center justify-start w-full gap-6">
                        <NavLink to="/hosts">
                            <div className="flex items-center gap-2">
                                <ArrowLeft className="w-6 h-6" />
                                <span className="text-[#646464] text-sm font-medium sr-only">Back to Hosts</span>
                            </div>
                        </NavLink>
                        <div className="w-[45px] aspect-square rounded-full bg-gradient-to-b from-dark to-secondary">
                            {agentLogo && <img src={agentLogo} alt="company logo" className="object-cover w-full h-full rounded-full" />}
                        </div>
                        {loading ? (
                            <span className="text-black text-[32px] font-bold animate-pulse">Loading...</span>
                        ) : (
                            <span className="text-black text-[32px] font-bold">{agentName}</span>
                        )}
                    </div>
                    <div className="w-fit flex items-center gap-0 border border-[#DBDBDB] rounded-lg ">
                        <div className="basis-5/12 px-8 py-5 flex flex-col justify-center items-center gap-3 p-6">
                            <span className="text-[13px] text-dark ">Orders</span>
                            <span className="text-[48px] leading-10 font-bold  ">{totalOrders}</span>
                        </div>
                        <Separator orientation="vertical" className="h-[90px] bg-[#DADADA]" />
                        <div className="basis-7/12 px-8 py-5 flex flex-col justify-center items-center gap-3 p-6">
                            <span className="text-[13px] text-dark ">Earnings</span>
                            <span className="text-[36px] leading-10 font-bold  ">{formatCurrency(totalEarnings)}</span>
                        </div>
                    </div>
                </div>
            </header>

            <div className="w-full">
                {/* List header */}
                <div className="flex items-center justify-between w-full mb-12">
                    <h2 className="text-[32px] text-dark font-medium">Listing</h2>
                </div>

                {/* List body */}
                <div className="w-full overflow-x-auto mb-10">
                    <div className="min-w-[800px] grid gap-6">
                        {loading ? (
                            <div className="w-full space-y-6">
                                {[...Array(5)].map((_, idx) => (
                                    <div key={idx} className="w-full bg-[#EBEBEB] rounded-lg animate-pulse">
                                        <div className="w-full px-5 py-[18px] flex justify-between items-center gap-5 md:gap-10">
                                            <div className="w-[59px] h-[59px] rounded-full bg-gray-300"></div>
                                            <div className="w-full grid flex-1 grid-cols-4 gap-3 lg:gap-5">
                                                {[...Array(4)].map((_, colIdx) => (
                                                    <div key={colIdx} className="flex flex-col min-w-0 gap-1">
                                                        <div className="h-4 bg-gray-300 rounded w-20 mb-2"></div>
                                                        <div className="h-6 bg-gray-300 rounded w-28"></div>
                                                    </div>
                                                ))}
                                            </div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        ) : serviceType === 'apartment' ? (
                            apartments.length ? (
                                apartments.map((apartment, idx) => (
                                    <HostListingItem
                                        key={idx}
                                        serviceType="apartment"
                                        _id={apartment._id}
                                        photo={apartment.apartmentImages[0]}
                                        name={apartment.apartmentName}
                                        location={apartment.address}
                                        rating={apartment.averageRating ?? 0}
                                        status={apartment.status}
                                        metadata={apartment}
                                    />
                                ))
                            ) : (
                                <div className="flex justify-center items-center py-8">
                                    <p className="text-gray-500">No apartments found</p>
                                </div>
                            )
                        ) : serviceType === 'ride' ? (
                            rides.length ? (
                                rides.map((ride, idx) => (
                                    <HostListingItem
                                        key={idx}
                                        serviceType="ride"
                                        _id={ride._id}
                                        photo={ride.rideImages[0]}
                                        name={ride.rideName}
                                        location={ride.address}
                                        rating={ride.averageRating ?? 0}
                                        status={ride.status}
                                        metadata={ride}
                                    />
                                ))
                            ) : (
                                <div className="flex justify-center items-center py-8">
                                    <p className="text-gray-500">No rides found</p>
                                </div>
                            )
                        ) : (
                            <div className="flex justify-center items-center py-8">
                                <p className="text-gray-500">No services found</p>
                            </div>
                        )}
                    </div>
                </div>

                {/* Pagination */}
                <ManualPaginationControl
                    pageIndex={pagination.pageIndex}
                    pageSize={pagination.pageSize}
                    totalPages={totalPages}
                    onChange={(pagination) => setPagination(pagination)}
                />

            </div>
        </section>
    )
}