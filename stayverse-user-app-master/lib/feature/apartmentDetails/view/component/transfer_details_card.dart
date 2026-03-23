import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/wallet/view/page/confirmation_page.dart';

class TransferSection extends StatelessWidget {
  final double? apartmentFee;
  final double? cautionFee;

  const TransferSection({
    super.key,
    required this.apartmentFee,
    required this.cautionFee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.color.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.color.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Breakdown',
            style: $styles.text.title1.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.color.primary,
            ),
          ),
          const Divider(height: 20),
          const DetailRow(
            label: 'Payment Type',
            value: 'Wallet Transfer',
          ),
          const SizedBox(height: 8),
          DetailRow(
            label: 'Apartment Fee',
            value: MoneyServiceV2.formatNaira(apartmentFee),
          ),
          const SizedBox(height: 8),
          DetailRow(
            label: 'Caution Fee',
            value: MoneyServiceV2.formatNaira(cautionFee),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                MoneyServiceV2.formatNaira(
                    (apartmentFee ?? 0) + (cautionFee ?? 0)),
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
