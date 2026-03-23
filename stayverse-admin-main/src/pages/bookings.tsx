import { BookingService } from "@/api/booking-service";
import BookingsDataTable from "@/components/bookings/BookingsDataTable";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { capitalize, formatCurrency, formatDate } from "@/lib/format.utils";
import { cn } from "@/lib/utils";
import { Booking, BookingStatus, BookingTableData } from "@/types/booking";
import { ColumnDef, createColumnHelper } from "@tanstack/react-table";
import { ChevronDownIcon, XIcon } from "lucide-react";
import { useEffect, useState } from "react";

const columnHelper = createColumnHelper<BookingTableData>();

const columns: ColumnDef<BookingTableData, any>[] = [
    columnHelper.accessor('serviceType', {
        header: 'Service Type',
        cell: ({ getValue }) => {
            const value = getValue();
            return (
                <span className="font-medium capitalize">
                    {value}
                </span>
            );
        }
    }),
    columnHelper.accessor('serviceName', {
        header: 'Service Name',
        cell: ({ getValue }) => {
            const value = getValue();
            return (
                <span className="max-w-[150px] truncate" title={value}>
                    {value}
                </span>
            );
        }
    }),
    columnHelper.accessor('customerName', {
        header: 'Customer',
        cell: ({ getValue }) => {
            const value = getValue();
            return (
                <span className="max-w-[120px] truncate" title={value}>
                    {value}
                </span>
            );
        }
    }),
    columnHelper.accessor('agentName', {
        header: 'Agent',
        cell: ({ getValue }) => {
            const value = getValue();
            return (
                <span className="max-w-[120px] truncate" title={value}>
                    {value}
                </span>
            );
        }
    }),
    {
        accessorKey: 'status',
        header: 'Status',
        cell: ({ row: { original: { status } } }) => {
            return (
                <div className={cn(
                    'w-full text-center gap-2 rounded-md min-w-[96px] py-[2px] capitalize',
                    status === BookingStatus.PENDING ? 'bg-[#FCC71F30] text-[#E89504]'
                        : status === BookingStatus.REJECTED ? 'bg-[#FF0A3630] text-[#FF0A0A]'
                            : status === BookingStatus.ACCEPTED ? 'bg-[#007BFF30] text-[#007BFF]'
                                : status === BookingStatus.COMPLETED ? 'bg-[#03732930] text-dark'
                                    : 'bg-gray-500 text-white',
                )}>
                    {status}
                </div>
            );
        }
    },
    columnHelper.accessor('fee', {
        header: 'Total Fee',
        cell: ({ row: { original } }) => formatCurrency(original.fee),
    }),
    columnHelper.accessor('startDate', {
        header: 'Start Date',
        cell: ({ getValue }) => {
            const value = getValue();
            return value || 'N/A';
        }
    }),
    columnHelper.accessor('endDate', {
        header: 'End Date',
        cell: ({ getValue }) => {
            const value = getValue();
            return value || 'N/A';
        }
    }),
]

export default function Bookings() {
    const [status, setStatus] = useState<BookingStatus>(BookingStatus.PENDING);
    const [startDate, setStartDate] = useState<Date>();
    const [endDate, setEndDate] = useState<Date>();
    const [bookings, setBookings] = useState<Booking[]>([]);
    const [bookingsTableData, setBookingsTableData] = useState<BookingTableData[]>([]);
    const [loading, setLoading] = useState(false);
    const [pagination, setPagination] = useState<{ pageIndex: number; pageSize: number }>({
        pageIndex: 0, 
        pageSize: 10,
    });
    const [totalPages, setTotalPages] = useState<number>(1);

    useEffect(() => {
        setLoading(true);
        BookingService.getAllBookings({ 
            page: pagination.pageIndex + 1, 
            limit: pagination.pageSize, 
            status,
            startDate: startDate?.toISOString(),
            endDate: endDate?.toISOString()
        }).then((res) => {
            if (res.data) {
                setBookings(res.data);
                setTotalPages(res.pagination.totalPages);
            }
        }).finally(() => {
            setLoading(false);
        });
    }, [pagination.pageIndex, pagination.pageSize, status, startDate, endDate]);

    useEffect(() => {
        const cleanedTableData: BookingTableData[] = [];
        
        for (const booking of bookings) {
            let serviceName = 'N/A';

            if (booking.serviceType === 'apartment' && booking.apartment) {
                serviceName = booking.apartment.apartmentName;
            } else if (booking.serviceType === 'ride' && booking.ride) {
                serviceName = booking.ride.rideName;
            } else if (booking.serviceType === 'chef' && booking.chef) {
                serviceName = booking.chef.fullName;
            }

            const startDate = booking.startDate ? formatDate(new Date(booking.startDate)) : 'N/A';
            const endDate = booking.endDate ? formatDate(new Date(booking.endDate)) : 'N/A';
            const customerName = booking.user ? `${booking.user.firstname} ${booking.user.lastname}` : 'N/A';
            const agentName = booking.agent?.user ? `${booking.agent.user.firstname} ${booking.agent.user.lastname}` : 'N/A';

            cleanedTableData.push({
                serviceType: booking.serviceType,
                serviceName,
                customerName,
                agentName,
                orderId: booking._id,
                status: booking.status,
                fee: booking.totalPrice,
                startDate,
                endDate,
            });
        }
        setBookingsTableData(cleanedTableData);
    }, [bookings])

    return (
        <section className="px-10 pb-12 pt-[30px] space-y-10 ">
            <div className="w-full flex items-center gap-5 flex-wrap">
                <div className="start gap-4 flex-wrap">
                    <h1 className="font-medium text-dark text-[32px]">Bookings</h1>
                    <div className="start gap-4">
                        {Object.values(BookingStatus).map((selectedStatus) => (
                            <button
                                key={selectedStatus}
                                onClick={() => setStatus(selectedStatus)}
                                className={`px-[18px] py-2 font-medium text-base rounded-sm relative transition-all cursor-pointer
                                ${selectedStatus === status ? "bg-primary-500 text-white" : "bg-[#EBEBEB] text-[#50555C]"}`}
                            >
                                {capitalize(selectedStatus)}
                            </button>
                        ))}
                    </div>
                </div>
                <div className="ml-auto end gap-4">

                    {(startDate || endDate) && (
                        <span
                            role="button"
                            className="px-3 py-2 text-sm border rounded-2xl center gap-2"
                            onClick={() => {
                                setStartDate(undefined); setEndDate(undefined);
                            }}
                        >Reset <XIcon size={12} /></span>
                    )}

                    <Popover >
                        <PopoverTrigger asChild>
                            <Button
                                variant="outline"
                                id="date"
                                className="w-40 justify-between font-normal"
                            >
                                {startDate ? startDate.toLocaleDateString() : "Start date"}
                                <ChevronDownIcon />
                            </Button>
                        </PopoverTrigger>
                        <PopoverContent className="w-auto overflow-hidden p-0" align="start">
                            <Calendar
                                mode="single"
                                selected={startDate}
                                captionLayout="dropdown"
                                onSelect={(date) => {
                                    setStartDate(date)
                                }}
                            />
                        </PopoverContent>
                    </Popover>

                    <Popover >
                        <PopoverTrigger asChild>
                            <Button
                                variant="outline"
                                id="date"
                                className="w-40 justify-between font-normal"
                            >
                                {endDate ? endDate.toLocaleDateString() : "End date"}
                                <ChevronDownIcon />
                            </Button>
                        </PopoverTrigger>
                        <PopoverContent className="w-auto overflow-hidden p-0" align="start">
                            <Calendar
                                mode="single"
                                selected={endDate}
                                captionLayout="dropdown"
                                onSelect={(date) => {
                                    setEndDate(date)
                                }}
                            />
                        </PopoverContent>
                    </Popover>
                </div>
            </div>

            <div className="container !px-0 mx-auto">
                <BookingsDataTable
                    columns={columns}
                    data={bookingsTableData}
                    loading={loading}
                    pagination={{
                        ...pagination,
                        totalPages: totalPages,
                        onChange: (pagination) => setPagination(pagination)
                    }}
                />
            </div>
        </section>
    )
}