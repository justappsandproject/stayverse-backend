export function  generateTransactionReference(): string {
    const date = new Date();
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth() + 1).padStart(2, '0');
    const dd = String(date.getDate()).padStart(2, '0');
    const hh = String(date.getHours()).padStart(2, '0');
    const min = String(date.getMinutes()).padStart(2, '0');
    const ss = String(date.getSeconds()).padStart(2, '0');
    const random = Math.random().toString(36).substring(2, 8).toUpperCase();
    return `tx-${yyyy}${mm}${dd}${hh}${min}${ss}-${random}`;
  }