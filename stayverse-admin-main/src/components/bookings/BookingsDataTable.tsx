import * as React from "react"
import {
    ColumnDef,
    ColumnFiltersState,
    PaginationState,
    SortingState,
    VisibilityState,
    flexRender,
    getCoreRowModel,
    getFilteredRowModel,
    useReactTable,
} from "@tanstack/react-table"
import { Link } from "react-router-dom"
import { PaginationProps } from "@/types/"
import { RotateCcwIcon } from "lucide-react"
import { ManualPaginationControl } from "../ManualPagination"
import { BookingTableData } from "@/types/booking"
import { cn } from "@/lib/utils"




interface DataTableProps<T, TValue> {
    loading: boolean;
    columns: ColumnDef<T, TValue>[];
    data: T[];
    setData?: (arg: T[] | ((prev: T[]) => T[])) => void;
    searchText?: string;
    pagination: PaginationProps;
}
export default function BookingsDataTable<TData = BookingTableData, TValue = any>(props: DataTableProps<TData, TValue>) {
    const { columns, data, loading, pagination } = props;

    const [rowSelection, setRowSelection] = React.useState({})
    const [columnVisibility, setColumnVisibility] = React.useState<VisibilityState>({})
    const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>([])
    const [sorting, setSorting] = React.useState<SortingState>([])

    // Handle pagination changes
    const handlePaginationChange = (updater: PaginationState | ((prev: PaginationState) => PaginationState)) => {
        if (pagination.onChange) {
            const newState = typeof updater === "function" ? updater(pagination) : updater;
            pagination.onChange(newState);
        }
    };

    const table = useReactTable({
        data,
        columns,
        state: {
            sorting,
            columnVisibility,
            rowSelection,
            columnFilters,
            pagination: { pageIndex: pagination.pageIndex, pageSize: pagination.pageSize }
        },
        enableRowSelection: true,
        manualPagination: true,
        pageCount: pagination?.totalPages,
        onRowSelectionChange: setRowSelection,
        onSortingChange: setSorting,
        onPaginationChange: handlePaginationChange,
        onColumnFiltersChange: setColumnFilters,
        onColumnVisibilityChange: setColumnVisibility,
        getCoreRowModel: getCoreRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
    })

    return (
        <div className="space-y-4">
            <div className="rounded-md relative w-full overflow-auto ">

                {/* Table */}
                <div className="w-full min-w-[1000px]">
                    {/* Table Head */}
                    <div className="bg-light text-base font-bold text-[#454647] rounded-lg mb-[23px] grid grid-cols-[repeat(auto-fit,minmax(100px,1fr))]">
                        {table.getHeaderGroups().map((headerGroup) =>
                            headerGroup.headers.map((header) => (
                                <div
                                    key={header.id}
                                    className="p-3 "
                                >
                                    {header.isPlaceholder
                                        ? null
                                        : flexRender(header.column.columnDef.header, header.getContext())}
                                </div>
                            ))
                        )}
                    </div>

                    {/* Table Body */}
                    {loading ? (
                        <div className="w-full min-h-[100px] center">
                            <RotateCcwIcon className="animate-spin h-10 w-10 text-dark" />
                        </div>
                    ) : (
                        <div className="w-full _bg-light rounded-lg text-[#505050] [&>*]:border-b-[0.5px] [&>*]:border-[#989898] ">
                            {table.getRowModel().rows?.length ? (
                                table.getRowModel().rows.map((row) => (
                                    <Link key={row.id} to={'/bookings/' + (row.original as BookingTableData)?.orderId} className={'w-full'}>
                                        <div
                                            key={row.id}
                                            className={cn(
                                                'grid grid-cols-[repeat(auto-fit,minmax(100px,1fr))] gap-1 px-3 lg:px-5',
                                                row.getIsSelected() && 'bg-blue-50',
                                                'border-b-[0.5px] '
                                            )}
                                        >
                                            {row.getVisibleCells().map((cell) => (
                                                <div
                                                    key={cell.id}
                                                    className="py-3 flex items-center mx-auto text-sm"
                                                >
                                                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                                                </div>
                                            ))}
                                        </div>
                                    </Link>
                                ))
                            ) : (
                                <div className="grid grid-cols-[repeat(auto-fill,minmax(100px,1fr))]">
                                    <div className="col-span-full h-24 flex items-center justify-center text-center text-gray-500">
                                        No results.
                                    </div>
                                </div>
                            )}
                        </div>
                    )}
                </div>

            </div>
            <ManualPaginationControl
                pageIndex={pagination.pageIndex}
                pageSize={pagination.pageSize}
                totalPages={pagination?.totalPages ?? table.getPageCount()}
                onChange={(newState: PaginationState) => {
                    if (pagination?.onChange) pagination.onChange(newState)
                }}
            />
        </div>
    )
}