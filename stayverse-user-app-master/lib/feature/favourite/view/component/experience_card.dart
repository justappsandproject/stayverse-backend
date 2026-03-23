import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/service/date_time_service.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String startDate, endDate;
  final String state;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: $styles.text.title2.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          company,
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateTimeService.formatExperienceRange(startDate, endDate),
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          state,
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
