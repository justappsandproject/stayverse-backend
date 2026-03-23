import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { cn } from "@/lib/utils"
import { RotateCcwIcon } from "lucide-react"
import { formatCurrency } from "@/lib/format.utils"
import { Transaction } from "@/api/payment-service"


interface TransactionsTableProps {
    data: Transaction[]
    loading: boolean
}

export default function TransactionTable({ data, loading }: TransactionsTableProps) {
    return (
        <div className="w-full max-w-7xl _mx-auto _p-4">
            <div className="rounded-lg border border-gray-200 overflow-hidden">
                <Table>
                    <TableHeader className="bg-gray-50">
                        <TableRow className="border-b border-gray-200">
                            <TableHead className="py-4 px-6 text-gray-600 font-medium">Type</TableHead>
                            <TableHead className="py-4 px-6 text-gray-600 font-medium">Date</TableHead>
                            <TableHead className="py-4 px-6 text-gray-600 font-medium">Reference</TableHead>
                            <TableHead className="py-4 px-6 text-gray-600 font-medium">Amount</TableHead>
                            <TableHead className="py-4 px-6 text-gray-600 font-medium">Status</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {loading ? (
                            <TableRow>
                                <TableCell colSpan={5} className="py-8">
                                    <div className="w-full min-h-[60px] center">
                                        <RotateCcwIcon className="animate-spin h-6 w-6 text-dark" />
                                    </div>
                                </TableCell>
                            </TableRow>
                        ) : data.length ? (
                            data.map((transaction, index) => (
                                <TableRow key={transaction._id ?? index} className={index % 2 === 0 ? "bg-white" : "bg-gray-50"}>
                                    <TableCell className="py-4 px-6">
                                        <div>
                                            <p className="font-normal text-gray-900 capitalize">{transaction.type}</p>
                                            <p className="text-sm text-gray-500">{transaction.description}</p>
                                        </div>
                                    </TableCell>
                                    <TableCell className="py-4 px-6">
                                        <p className="font-normal text-gray-900">{new Date(transaction.createdAt).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</p>
                                        <p className="text-sm text-gray-500">{new Date(transaction.createdAt).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</p>
                                    </TableCell>
                                    <TableCell className="py-4 px-6 text-gray-900">{transaction.reference}</TableCell>
                                    <TableCell className="py-4 px-6 font-normal text-gray-900">{formatCurrency(transaction.amount)}</TableCell>
                                    <TableCell className="py-4 px-6">
                                        <span
                                            className={cn(
                                                'inline-flex justify-center w-full max-w-[140px] px-4 py-2 rounded-[7px] text-sm font-normal capitalize',
                                                transaction.status === 'successful' ? 'bg-[#039836] text-white' :
                                                transaction.status === 'pending' ? 'bg-[#FFB800] text-white' :
                                                'bg-[#FF0A0A] text-white'
                                            )}
                                        >
                                            {transaction.status}
                                        </span>
                                    </TableCell>
                                </TableRow>
                            ))
                        ) : (
                            <TableRow>
                                <TableCell colSpan={5} className="py-8">
                                    <div className="w-full text-center text-gray-500">No results.</div>
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>
        </div>
    )
}

