import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleCalendar extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? selectedDate;
  final DateTime? initialDate;
  final Color selectedColor;
  final bool darkMode;
  final bool showOutsideDays;
  final double height;

  const SingleCalendar({
    super.key,
    this.onDateSelected,
    this.height = 350,
    this.selectedDate,
    this.initialDate,
    this.selectedColor = const Color(0xFF2563EB),
    this.darkMode = false,
    this.showOutsideDays = true,
  });

  @override
  State<SingleCalendar> createState() => _SingleCalendarState();
}

class _SingleCalendarState extends State<SingleCalendar> {
  late DateTime _currentMonth;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
    _selectedDate = widget.selectedDate;
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
    final DateTime firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final DateTime lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Find the Monday before or on the first day of month
    DateTime firstDayOfCalendar = firstDayOfMonth;
    while (firstDayOfCalendar.weekday != DateTime.monday) {
      firstDayOfCalendar = firstDayOfCalendar.subtract(const Duration(days: 1));
    }

    // Find the Sunday after or on the last day of month
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

  void _handleDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;

      // Notify parent about the selection
      widget.onDateSelected?.call(_selectedDate!);
    });
  }

  bool _isSelected(DateTime date) {
    return _selectedDate != null && isSameDay(date, _selectedDate!);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> daysInMonth = _getDaysInMonth();
    final bgColor = widget.darkMode ? const Color(0xFF09090B) : Colors.white;
    final textColor = widget.darkMode ? Colors.white : Colors.black;
    final mutedTextColor = widget.darkMode ? Colors.white70 : Colors.black54;
    final weekdayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: textColor),
                  onPressed: _goToPreviousMonth,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_currentMonth),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: textColor),
                  onPressed: _goToNextMonth,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: weekdayLabels
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: mutedTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      addRepaintBoundaries: true,
                      shrinkWrap: false,
                      physics: const ClampingScrollPhysics(),
                      crossAxisCount: 7,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(daysInMonth.length, (index) {
                        final date = daysInMonth[index];
                        final isCurrentMonth =
                            date.month == _currentMonth.month;
                        final isToday = _isToday(date);
                        final isSelected = _isSelected(date);

                        if (!isCurrentMonth && !widget.showOutsideDays) {
                          return const SizedBox();
                        }

                        Color cellBgColor = Colors.transparent;
                        if (isSelected) {
                          cellBgColor = widget.selectedColor;
                        }

                        Color cellTextColor = textColor;
                        if (!isCurrentMonth) {
                          cellTextColor = mutedTextColor.withOpacity(0.5);
                        }
                        if (isSelected) {
                          cellTextColor = Colors.white;
                        }

                        BoxBorder? cellBorder;
                        if (isToday && !isSelected) {
                          cellBorder = Border.all(color: textColor, width: 1);
                        }

                        return GestureDetector(
                          onTap: isCurrentMonth
                              ? () => _handleDateTap(date)
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellBgColor,
                              borderRadius: BorderRadius.circular(4),
                              border: cellBorder,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color: cellTextColor,
                                  fontWeight: isToday || isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
