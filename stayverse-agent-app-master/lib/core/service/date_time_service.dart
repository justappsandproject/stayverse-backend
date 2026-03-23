import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DateTimeService {
  static String format(DateTime? dateTime, {String? format}) {
    if (isObjectEmpty(dateTime)) return "";

    return DateFormat(format ?? 'dd MMM yyyy', 'en_US').format(dateTime!);
  }

  static String formatTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return 'N/A';

    try {
      final dateTime = DateTime.parse(isoTime);
      return DateFormat('h:mm a').format(dateTime); // 7:00 AM, 9:30 PM
    } catch (e) {
      return 'Invalid time';
    }
  }

  static bool isSameMonthYear(DateTime date1, DateTime date2) {
    return date1.month == date2.month && date1.year == date2.year;
  }

  static bool isSameMonthYearDay(DateTime date1, DateTime date2) {
    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day;
  }

  ///Get data time from current time now
  static String dateTimeFromNow(DateTime? dateTime, context) {
    try {
      if (isObjectEmpty(dateTime)) return '';

      final lastDate = dateTime!.toLocal();

      String stringDate;

      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);

      if (lastDate.millisecondsSinceEpoch >=
          startOfDay.millisecondsSinceEpoch) {
        stringDate = Jiffy.parseFromDateTime(lastDate.toLocal()).jm;
      } else if (lastDate.millisecondsSinceEpoch >=
          startOfDay.subtract(const Duration(days: 1)).millisecondsSinceEpoch) {
        stringDate = 'yesterday';
      } else if (startOfDay.difference(lastDate).inDays < 7) {
        stringDate = Jiffy.parseFromDateTime(lastDate.toLocal()).EEEE;
      } else {
        stringDate = Jiffy.parseFromDateTime(lastDate.toLocal()).yMd;
      }

      return stringDate;
    } catch (e) {
      return "";
    }
  }

  static String get getTimeOfDay {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  static String formatExperienceRange(String? start, String? end) {
    if (start == null || start.isEmpty) return '';

    try {
      final startDate = DateTime.parse(start);
      final isPresent =
          end == null || end.isEmpty || end.toLowerCase() == 'present';

      final endDate = isPresent ? null : DateTime.parse(end);

      final startFormatted = DateFormat('MMM. yyyy').format(startDate);
      final endFormatted =
          isPresent ? 'Present' : DateFormat('MMM. yyyy').format(endDate!);

      String result = '$startFormatted - $endFormatted';

      if (endDate != null) {
        final duration = _calculateDuration(startDate, endDate);
        result += ' $duration';
      }

      return result;
    } catch (e) {
      return '';
    }
  }

  static String _calculateDuration(DateTime start, DateTime end) {
    int years = end.year - start.year;
    int months = end.month - start.month;

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    String yearPart = years > 0 ? '${years}yr' : '';
    String monthPart = months > 0 ? '${months}mo' : '';

    if (yearPart.isNotEmpty && monthPart.isNotEmpty) {
      return '$yearPart $monthPart';
    } else {
      return yearPart + monthPart;
    }
  }

  static String calculateDurationInDays(
      DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';

    final difference = endDate.difference(startDate).inDays;

    // If both days are the same, count as 1 day stay.
    final totalDays = difference <= 0 ? 1 : difference;

    return '$totalDays ${totalDays == 1 ? "Day" : "Days"}';
  }

   static String calculateDurationInHours(
      DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';

    final difference = endDate.difference(startDate).inHours;
    // If both days are the same, count as 1 day stay.
    final totalDays = difference <= 0 ? 1 : difference;

    return '$totalDays ${totalDays == 1 ? "Hour" : "Hours"}';
  }
}

extension DateTimeX on DateTime? {
  bool isSameMonthAndYear(DateTime? date) {
    if (this == null) return false;

    if (date == null) return false;

    return DateTimeService.isSameMonthYear(this!, date);
  }

  bool isSame(DateTime? date) {
    if (this == null) return false;

    if (date == null) return false;

    return DateTimeService.isSameMonthYearDay(this!, date);
  }
}
