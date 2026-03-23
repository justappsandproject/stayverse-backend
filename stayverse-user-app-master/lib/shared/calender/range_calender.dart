import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RangeCalendar extends StatefulWidget {
  final Function(DateTimeRange)? onRangeSelected;
  final DateTimeRange? selectedRange;
  final DateTime? initialDate;
  final Color rangeColor;
  final Color selectedColor;
  final Color blockedColor;
  final bool darkMode;
  final bool showOutsideDays;
  final bool blockPastDays;
  final List<DateTime> blockedDates;
  final double height;

  const RangeCalendar({
    super.key,
    this.onRangeSelected,
    this.height = 350,
    this.selectedRange,
    this.initialDate,
    this.rangeColor = const Color(0xFF3B82F6),
    this.selectedColor = const Color(0xFF2563EB),
    this.blockedColor = const Color(0xFFEF4444),
    this.darkMode = false,
    this.showOutsideDays = true,
    this.blockPastDays = false,
    this.blockedDates = const [],
  });

  @override
  State<RangeCalendar> createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<RangeCalendar> {
  late DateTime _currentMonth;
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;
  late bool _isSelecting;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
    if (widget.selectedRange != null) {
      _rangeStart = widget.selectedRange!.start;
      _rangeEnd = widget.selectedRange!.end;
    } else {
      _rangeStart = null;
      _rangeEnd = null;
    }

    _isSelecting = false;
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

  bool _isDateBlocked(DateTime date) {
    // Check if date is in the blocked dates list
    for (DateTime blockedDate in widget.blockedDates) {
      if (isSameDay(date, blockedDate)) {
        return true;
      }
    }

    // Check if past days should be blocked
    if (widget.blockPastDays) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final checkDate = DateTime(date.year, date.month, date.day);

      if (checkDate.isBefore(todayDate)) {
        return true;
      }
    }

    return false;
  }

  void _handleDateTap(DateTime date) {
    if (_isDateBlocked(date)) {
      return;
    }

    setState(() {
      if (!_isSelecting || _rangeStart == null) {
        // Start selecting a new range
        _rangeStart = date;
        _rangeEnd = null;
        _isSelecting = true;
      } else {
        // Complete the range selection
        DateTime startDate, endDate;

        if (date.isBefore(_rangeStart!)) {
          // If tapped date is before start, swap them
          startDate = date;
          endDate = _rangeStart!;
        } else {
          startDate = _rangeStart!;
          endDate = date;
        }

        // Check if any date in the range is blocked
        bool rangeHasBlockedDates = false;
        DateTime checkDate = startDate;

        while (checkDate.isBefore(endDate.add(const Duration(days: 1)))) {
          if (_isDateBlocked(checkDate)) {
            rangeHasBlockedDates = true;
            break;
          }
          checkDate = checkDate.add(const Duration(days: 1));
        }

        // Only set the range if no blocked dates are in between
        if (!rangeHasBlockedDates) {
          _rangeStart = startDate;
          _rangeEnd = endDate;
          _isSelecting = false;

          // Notify parent about the selection
          widget.onRangeSelected?.call(DateTimeRange(
            start: _rangeStart!,
            end: _rangeEnd!,
          ));
        } else {
          // If range contains blocked dates, start a new selection
          _rangeStart = date;
          _rangeEnd = null;
          _isSelecting = true;
        }
      }
    });
  }

  bool _isInRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) return false;

    return (date.isAtSameMomentAs(_rangeStart!) ||
            date.isAfter(_rangeStart!)) &&
        (date.isAtSameMomentAs(_rangeEnd!) || date.isBefore(_rangeEnd!));
  }

  bool _isRangeBoundary(DateTime date) {
    if (_rangeStart == null) return false;

    return isSameDay(date, _rangeStart!) ||
        (_rangeEnd != null && isSameDay(date, _rangeEnd!));
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
                        final isInRange = _isInRange(date);
                        final isRangeBoundary = _isRangeBoundary(date);
                        final isBlocked = _isDateBlocked(date);

                        if (!isCurrentMonth && !widget.showOutsideDays) {
                          return const SizedBox();
                        }

                        Color cellBgColor = Colors.transparent;
                        if (isBlocked) {
                          cellBgColor = widget.blockedColor.withOpacity(0.2);
                        } else if (isRangeBoundary) {
                          cellBgColor = widget.selectedColor;
                        } else if (isInRange) {
                          cellBgColor = widget.rangeColor.withOpacity(0.2);
                        }

                        Color cellTextColor = textColor;
                        if (!isCurrentMonth) {
                          cellTextColor = mutedTextColor.withOpacity(0.5);
                        }
                        if (isBlocked) {
                          cellTextColor = widget.blockedColor.withOpacity(0.7);
                        } else if (isRangeBoundary) {
                          cellTextColor = Colors.white;
                        }

                        BoxBorder? cellBorder;
                        if (isToday &&
                            !isRangeBoundary &&
                            !isInRange &&
                            !isBlocked) {
                          cellBorder = Border.all(color: textColor, width: 1);
                        }

                        return GestureDetector(
                          onTap: !isBlocked ? () => _handleDateTap(date) : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellBgColor,
                              borderRadius: BorderRadius.circular(4),
                              border: cellBorder,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      color: cellTextColor,
                                      fontWeight: isToday || isRangeBoundary
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 14,
                                      decoration: isBlocked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ],
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
