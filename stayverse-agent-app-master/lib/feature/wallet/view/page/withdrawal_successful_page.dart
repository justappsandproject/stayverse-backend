import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/wallet/model/data/withdrawal_success_data.dart';
import 'package:stayvers_agent/feature/wallet/view/component/header_component.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

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
          30.sbH,
          formattedAmount.txt(
            size: 28,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          30.sbH,
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryyellow),
                    color: AppColors.yellowD7,
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
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            bgColor: AppColors.primaryyellow,
            onPressed: () {
              $navigate.back();
            },
          ).paddingOnly(left: 22, right: 19),
          24.sbH,
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
          style: const TextStyle(
            fontFamily: Constant.sora,
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: Constant.montreal,
                color: AppColors.black,
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
