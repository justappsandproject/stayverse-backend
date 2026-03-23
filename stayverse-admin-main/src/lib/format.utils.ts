

export function formatCurrency(amount: number, minimumFractionDigits = 0, currency = 'NGN') {
    return new Intl.NumberFormat('en-NG', {
        style: 'currency',
        currency,
        minimumFractionDigits
    }).format(amount);
}

export function capitalize(str: string): string {
    if (!str) return "";
    return str.charAt(0).toUpperCase() + str.slice(1);
}

export const formatDate = (date?: Date | number) => {
    const options: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'short', hour: 'numeric', minute: 'numeric', hour12: true };
    return new Intl.DateTimeFormat('en-US', options).format(date);
};

export const formatMonthYear = (date?: Date | number) => {
    const options: Intl.DateTimeFormatOptions = { month: 'short', year: 'numeric' };
    return new Intl.DateTimeFormat('en-US', options).format(date);
};
