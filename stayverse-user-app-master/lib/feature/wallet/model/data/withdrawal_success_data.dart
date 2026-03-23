// Data model to pass withdrawal information
class WithdrawalSuccessData {
  final double? amount;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final DateTime timestamp;
  final double? fee;

  WithdrawalSuccessData({
    required this.amount,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.timestamp,
    this.fee,
  });

  String get formattedTime {
    final day = timestamp.day;
    final monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = monthNames[timestamp.month];
    final year = timestamp.year;
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$day${_getDaySuffix(day)} $month. $year | $displayHour:$minute$amPm';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}