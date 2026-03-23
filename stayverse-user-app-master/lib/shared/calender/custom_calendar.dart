import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? selectedDate;

  const CustomCalendar({
    super.key,
    this.onDateSelected,
    this.selectedDate,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month, 1)
          .subtract(const Duration(days: 1));
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final DateTime firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final DateTime lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    DateTime firstDayOfCalendar = firstDayOfMonth;
    while (firstDayOfCalendar.weekday != DateTime.monday) {
      firstDayOfCalendar = firstDayOfCalendar.subtract(const Duration(days: 1));
    }

    DateTime lastDayOfCalendar = lastDayOfMonth;
    while (lastDayOfCalendar.weekday != DateTime.sunday) {
      lastDayOfCalendar = lastDayOfCalendar.add(const Duration(days: 1));
    }

    final List<DateTime> daysInMonth = [];
    DateTime currentDay = firstDayOfCalendar;
    while (
        currentDay.isBefore(lastDayOfCalendar.add(const Duration(days: 1)))) {
      daysInMonth.add(currentDay);
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return daysInMonth;
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
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  onPressed: _goToPreviousMonth,
                  color: Colors.black,
                ),
              ),
              Positioned(
                right: -20,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                  onPressed: _goToNextMonth,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Gap(40),
                        ...['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                            .map((day) => SizedBox(
                                  width: screenWidth / 7 - 16,
                                  child: Text(
                                    day,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )),
                      ],
                    ),
                    const Gap(8),
                    ...List.generate(6, (weekIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                              '${weekIndex + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...List.generate(7, (dayIndex) {
                            final dayNumber = weekIndex * 7 + dayIndex;
                            if (dayNumber >= daysInMonth.length) {
                              return const Gap(40);
                            }

                            final date = daysInMonth[dayNumber];
                            final isCurrentMonth =
                                date.month == _currentMonth.month;
                            final isSelected =
                                _selectedDate.year == date.year &&
                                    _selectedDate.month == date.month &&
                                    _selectedDate.day == date.day;

                            return SizedBox(
                              width: screenWidth / 7 - 16,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                  widget.onDateSelected?.call(date);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFB800)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      color: isCurrentMonth
                                          ? Colors.black
                                          : Colors.grey[400],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
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
