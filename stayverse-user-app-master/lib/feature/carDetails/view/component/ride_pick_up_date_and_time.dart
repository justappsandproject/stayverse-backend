import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/shared/date_time_picker.dart';

class RidePickUpDateAndTime extends StatefulWidget {
  final void Function(DateTime isoDateTime)? onDateTimeSelected;
  const RidePickUpDateAndTime({super.key, this.onDateTimeSelected});

  @override
  State<RidePickUpDateAndTime> createState() => _RidePickUpDateAndTimeState();
}

class _RidePickUpDateAndTimeState extends State<RidePickUpDateAndTime> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void tryCombine() {
    if (selectedDate != null && selectedTime != null) {
      final combined = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ).toUtc();

      widget.onDateTimeSelected?.call(combined);
    }
  }

  void pickDate() {
    showAppDatePicker(context, onConfirm: (date) {
      setState(() => selectedDate = date);
      tryCombine();
    });
  }

  void pickTime() {
    showAppDateTimePicker(context, onConfirm: (dateTime) {
      setState(() {
        selectedTime = TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute,
        );
      });
      tryCombine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : '';

    final formattedTime =
        selectedTime != null ? selectedTime!.format(context) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATE + TIME ROW
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: pickDate,
                child: PickerBox(
                  icon: Icons.calendar_month_rounded,
                  text: formattedDate.isEmpty ? "Select date" : formattedDate,
                  isPlaceholder: formattedDate.isEmpty,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: pickTime,
                child: PickerBox(
                  icon: Icons.access_time,
                  text: formattedTime.isEmpty ? "Select time" : formattedTime,
                  isPlaceholder: formattedTime.isEmpty,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PickerBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isPlaceholder;

  const PickerBox({
    super.key,
    required this.icon,
    required this.text,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFF2A900)),
          const SizedBox(width: 12),
          Text(
            text,
            style: isPlaceholder
                ? $styles.text.bodySmall.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)
                : $styles.text.title1.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
