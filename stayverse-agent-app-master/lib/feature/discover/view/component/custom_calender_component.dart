import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const CustomCalendar({
    super.key,
    this.startDate,
    this.endDate,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();

    // If startDate exists, use its month, otherwise default to current month
    if (widget.startDate != null) {
      _currentMonth =
          DateTime(widget.startDate!.year, widget.startDate!.month, 1);
    } else {
      _currentMonth = DateTime.now();
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Backtrack to Monday
    DateTime start = firstOfMonth;
    while (start.weekday != DateTime.monday) {
      start = start.subtract(const Duration(days: 1));
    }

    // Forward to Sunday
    DateTime end = lastOfMonth;
    while (end.weekday != DateTime.sunday) {
      end = end.add(const Duration(days: 1));
    }

    List<DateTime> days = [];
    for (DateTime d = start;
        !d.isAfter(end);
        d = d.add(const Duration(days: 1))) {
      days.add(d);
    }
    return days;
  }

  bool _isInRange(DateTime date) {
    if (widget.startDate == null || widget.endDate == null) return false;
    return !date.isBefore(widget.startDate!) &&
        !date.isAfter(widget.endDate!) &&
        date.month == _currentMonth.month;
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> daysInMonth = _getDaysInMonth();
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              DateFormat('MMMM yyyy').format(_currentMonth),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: -20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, size: 30),
                  onPressed: _goToPreviousMonth,
                  color: Colors.black,
                ),
              ),
              Positioned(
                right: -20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, size: 30),
                  onPressed: _goToNextMonth,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Header row (Mon–Sun)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                            .map((day) => SizedBox(
                                  width: (screenWidth - 64) / 7,
                                  child: Text(
                                    day,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )),
                      ],
                    ),
                    const Gap(8),
                    // Days grid (no week numbers anymore)
                    ...List.generate(6, (weekIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(7, (dayIndex) {
                          final dayNumber = weekIndex * 7 + dayIndex;
                          if (dayNumber >= daysInMonth.length) {
                            return const SizedBox(width: 40);
                          }

                          final date = daysInMonth[dayNumber];
                          final isCurrentMonth =
                              date.month == _currentMonth.month;
                          final isToday = DateTime.now().year == date.year &&
                              DateTime.now().month == date.month &&
                              DateTime.now().day == date.day;
                          final isInRange = _isInRange(date);

                          return SizedBox(
                            width: (screenWidth - 64) / 7,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isInRange
                                    ? const Color(0xFFFFB800)
                                    : isToday
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: isToday
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                              child: Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color: isCurrentMonth
                                      ? (isInRange
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.grey[400],
                                  fontWeight: isInRange || isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
