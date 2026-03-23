import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';

class BookingInfoSection extends StatelessWidget {
  final double totalPrice;
  final DateTime? startDate;
  final DateTime? endDate;

  const BookingInfoSection({
    super.key,
    required this.totalPrice,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateTimeService.daysBetween(startDate!, endDate!)} Days (${DateTimeService.format(startDate, format: 'MMM dd, yyyy')} - ${DateTimeService.format(endDate, format: 'MMM dd, yyyy')})',
            style: $styles.text.body.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MoneyServiceV2.formatNaira(totalPrice, decimalDigits: 0),
                style: $styles.text.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Paid',
                style: $styles.text.body.copyWith(
                  fontSize: 11.3,
                  fontWeight: FontWeight.w500,
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
