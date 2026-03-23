import {
    ChevronLeftIcon,
    ChevronRightIcon,
    ChevronsLeftIcon,
    ChevronsRightIcon,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";


interface ManualPaginationProps {
    pageIndex: number;
    pageSize: number;
    totalPages?: number;
    onChange?: (pagination: { pageIndex: number; pageSize: number }) => void;
}

export function ManualPaginationControl({ pageIndex, pageSize = 10, onChange, totalPages = 1 }: ManualPaginationProps) {
    // const { pageIndex, pageSize, totalPages = 1, onChange } = pagination;

    const handlePageChange = (newPageIndex: number) => {
        if (onChange) {
            onChange({ pageIndex: newPageIndex, pageSize });
        }
    };

    const handlePageSizeChange = (newPageSize: number) => {
        if (onChange) {
            onChange({ pageIndex: 0, pageSize: newPageSize }); // Reset to first page
        }
    };

    return (
        <div className="flex items-center justify-between px-2">
            <div className="flex-1" />
            <div className="flex items-center space-x-6 lg:space-x-8">
                {/* Page Size Selector */}
                <div className="flex items-center space-x-2">
                    <p className="text-sm font-medium">Limit</p>
                    <Select
                        value={`${pageSize}`}
                        onValueChange={(value) => handlePageSizeChange(Number(value))}
                    >
                        <SelectTrigger className="h-8 w-[70px]">
                            <SelectValue placeholder={pageSize} />
                        </SelectTrigger>
                        <SelectContent side="top">
                            {[5, 10, 20, 30, 40, 50].map((size) => (
                                <SelectItem key={size} value={`${size}`}>
                                    {size}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>

                {/* Page Info */}
                <div className="flex w-[100px] items-center justify-center text-sm font-medium">
                    Page {pageIndex + 1} of {totalPages}
                </div>

                {/* Navigation Buttons */}
                <div className="flex items-center space-x-2">
                    <Button
                        variant="outline"
                        className="hidden h-8 w-8 p-0 lg:flex"
                        onClick={() => handlePageChange(0)}
                        disabled={pageIndex === 0}
                    >
                        <span className="sr-only">Go to first page</span>
                        <ChevronsLeftIcon className="h-4 w-4" />
                    </Button>
                    <Button
                        variant="outline"
                        className="h-8 w-8 p-0"
                        onClick={() => handlePageChange(pageIndex - 1)}
                        disabled={pageIndex === 0}
                    >
                        <span className="sr-only">Go to previous page</span>
                        <ChevronLeftIcon className="h-4 w-4" />
                    </Button>
                    <Button
                        variant="outline"
                        className="h-8 w-8 p-0"
                        onClick={() => handlePageChange(pageIndex + 1)}
                        disabled={pageIndex + 1 >= totalPages}
                    >
                        <span className="sr-only">Go to next page</span>
                        <ChevronRightIcon className="h-4 w-4" />
                    </Button>
                    <Button
                        variant="outline"
                        className="hidden h-8 w-8 p-0 lg:flex"
                        onClick={() => handlePageChange(totalPages - 1)}
                        disabled={pageIndex + 1 >= totalPages}
                    >
                        <span className="sr-only">Go to last page</span>
                        <ChevronsRightIcon className="h-4 w-4" />
                    </Button>
                </div>
            </div>
        </div>
    );
}
