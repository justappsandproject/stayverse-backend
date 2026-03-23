import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/wallet/view/component/header_component.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'withdrawal_successful_page.dart';

class WithdrawRefundPage extends ConsumerWidget {
  static const route = '/WithdrawRefundPage';
  const WithdrawRefundPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      body: Column(
        children: [
          const HeaderComponent(
            useHeader: false,
            showBackIcon: false,
          ),
          const Spacer(),
          Column(
            children: [
              'Caution Refund'.txt14(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryyellow,
              ),
              'N1,000,000'.txt24(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              20.sbH,
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
                        label: 'Check-in Date', value: 'Wednesday 4th January'),
                    BuildDetailRow(label: 'Check-in Time', value: '12:00 PM'),
                    BuildDetailRow(
                        label: 'Location',
                        value: '7 Bayview street, Lekki Phase 1'),
                    BuildDetailRow(label: 'Apartment Host', value: 'Sensei'),
                  ],
                ),
              ).paddingOnly(left: 22, right: 19),
            ],
          ),
          60.sbH,
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
              $navigate.popUntil(2);
            },
          ).paddingOnly(left: 22, right: 19),
          24.sbH,
        ],
      ),
    );
  }
}
