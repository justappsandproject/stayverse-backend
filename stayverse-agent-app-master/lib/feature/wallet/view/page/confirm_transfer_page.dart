import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/feature/wallet/view/component/header_component.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../../core/util/style/app_colors.dart';
import '../../../../shared/buttons.dart';
import 'pin_input_page.dart';
import 'withdrawal_successful_page.dart';

class ConfirmTransferPage extends ConsumerWidget {
  static const route = '/ConfirmTransferPage';
  const ConfirmTransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      body: Column(
        children: [
          const HeaderComponent(
            headerTxt: 'Confirm Transfer',
            showBackIcon: true,
          ),
          30.sbH,
          'Total Payment'.txt14(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryyellow,
          ),
          'N1,000,000'.txt24(
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
                  child: const Column(
                    spacing: 24,
                    children: [
                      BuildDetailRow(
                          label: 'Payment Type', value: 'Bank Transfer'),
                      BuildDetailRow(label: 'Bank Name', value: 'Wema Bank'),
                      BuildDetailRow(
                          label: 'Account Name', value: 'Paystack TITAN'),
                      BuildDetailRow(
                        label: 'Account Number',
                        value: '8059834366',
                        ftCopy: true,
                      ),
                    ],
                  ),
                ).paddingOnly(left: 22, right: 19),
              ],
            ),
          ),
          AppBtn.from(
            text: 'I’ve made this transfer',
            expand: true,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            bgColor: AppColors.primaryyellow,
            onPressed: () {
              $navigate.to(PinInputPage.route);
            },
          ).paddingOnly(left: 22, right: 19),
          24.sbH,
        ],
      ),
    );
  }
}
