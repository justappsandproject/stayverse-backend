import TransactionTable from "@/components/transactions/TransactionsTable";
import { ManualPaginationControl } from "@/components/ManualPagination";
import { PaymentService } from "@/api/payment-service";
import { useEffect, useState } from "react";

interface Transaction {
    _id: string;
    reference: string;
    amount: number;
    type: 'credit' | 'debit';
    status: 'pending' | 'successful' | 'failed';
    userId: string;
    description: string;
    createdAt: string;
    updatedAt: string;
}

export default function Transactions() {
    const [transactions, setTransactions] = useState<Transaction[]>([]);
    const [loading, setLoading] = useState(false);
    const [pagination, setPagination] = useState<{ pageIndex: number; pageSize: number }>(
        { pageIndex: 0, pageSize: 10 }
    );
    const [totalPages, setTotalPages] = useState<number>(1);
    const [totalItems, setTotalItems] = useState<number>(0);

    useEffect(() => {
        setLoading(true);
        PaymentService.getAllTransactions({
            page: pagination.pageIndex + 1,
            limit: pagination.pageSize,
        }).then((res) => {
            setTransactions(res.data || []);
            setTotalPages(res.pagination?.totalPages || 1);
            setTotalItems(res.pagination?.totalItems || 0);
        }).finally(() => setLoading(false));
    }, [pagination.pageIndex, pagination.pageSize]);

    return (
        <section className="px-10 pb-12 pt-[30px] space-y-10 ">
            <div className="w-full flex items-center gap-5 flex-wrap">
                <h1 className="font-medium text-dark text-[32px]">Transactions</h1>
                <span className="ml-auto text-lg text-[#858585]">{totalItems} results</span>
            </div>

            <div className="container !px-0 mx-auto">
                <TransactionTable data={transactions} loading={loading} />
                <div className="mt-4">
                    <ManualPaginationControl
                        pageIndex={pagination.pageIndex}
                        pageSize={pagination.pageSize}
                        totalPages={totalPages}
                        onChange={(p) => setPagination(p)}
                    />
                </div>
            </div>
        </section>
    )
}