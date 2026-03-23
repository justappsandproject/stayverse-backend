

// Months
export const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

const getDaysInMonth = (month: number, year: number) => {
    return new Date(year, month + 1, 0).getDate();
};

export function generateDays(month: number, year: number): string[] {
    const totalDays = getDaysInMonth(month, year);
    return Array.from({ length: totalDays }, (_, i) => (i + 1).toString());
}

const START_YEAR = 2023;

export function generateYears(startYear = START_YEAR): string[] {
    const currentYear = new Date().getFullYear();
    return Array.from({ length: currentYear - startYear + 1 }, (_, i) => (startYear + i).toString());
}