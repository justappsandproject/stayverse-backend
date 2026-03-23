
export function validateAmountNumber(amount: number) {
    if (typeof amount !== 'number' || isNaN(amount)) {
        throw new Error('Amount must be a valid number');
    }
    if (amount <= 0) {
        throw new Error('Amount must be a positive number');
    }
    return parseInt(amount.toFixed(0));
}