import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';

class AmountDetailsSection extends StatelessWidget {
  final double? amount;

  const AmountDetailsSection({super.key, this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Total Payment',
          style: $styles.text.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.color.primary,
          ),
        ),
        Text(
          MoneyServiceV2.formatNaira(amount ?? 0),
          style: $styles.text.body.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
