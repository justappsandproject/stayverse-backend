import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_success_data.dart';
import 'package:stayverse/feature/wallet/view/component/header_component.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class WithdrawalSuccessfulPage extends ConsumerWidget {
  static const route = '/WithdrawalSuccessfulPage';
  final WithdrawalSuccessData withdrawalData;

  const WithdrawalSuccessfulPage({
    super.key,
    required this.withdrawalData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedAmount = MoneyServiceV2.formatNaira(withdrawalData.amount);

    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      body: Column(
        children: [
          const HeaderComponent(
            showBackIcon: true,
          ),
          const Gap(30),
          Text(
            formattedAmount,
            style: $styles.text.title1.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: $styles.colors.black,
            ),
          ),
          const Gap(30),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: context.themeColors.primaryAccent),
                    color: context.themeColors.primaryAccent.withOpacity(0.1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 22),
                  child: Column(
                    spacing: 24,
                    children: [
                      BuildDetailRow(
                        label: 'Bank',
                        value: withdrawalData.bankName ?? '',
                      ),
                      BuildDetailRow(
                        label: 'Account Name',
                        value: withdrawalData.accountName ?? '',
                      ),
                      BuildDetailRow(
                        label: 'Account Number',
                        value: withdrawalData.accountNumber ?? '',
                        ftCopy: true,
                      ),
                      BuildDetailRow(
                        label: 'Time',
                        value: withdrawalData.formattedTime,
                      ),
                    ],
                  ),
                ).paddingOnly(left: 22, right: 19),
              ],
            ),
          ),
          AppBtn.from(
            text: 'Back',
            expand: true,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: $styles.colors.black,
            ),
            bgColor: context.themeColors.primaryAccent,
            onPressed: () {
              $navigate.back();
            },
          ).paddingOnly(left: 22, right: 19),
          const Gap(24),
        ],
      ),
    );
  }
}

class BuildDetailRow extends StatelessWidget {
  final String label, value;
  final bool ftCopy;
  const BuildDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.ftCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: Constant.sora,
            color: $styles.colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: Constant.montreal,
                color: $styles.colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            ftCopy
                ? GestureDetector(
                    onTap: () {
                      // Copy to clipboard functionality
                      // You can implement this using Clipboard.setData()
                    },
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 12,
                    ).paddingOnly(left: 4),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
