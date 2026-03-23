import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'confirm_transfer_page.dart';

class AddFundsPage extends ConsumerWidget {
  static const route = '/AddFundsPage';
  const AddFundsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrimSkeleton(
        appBar: AppBar(
          centerTitle: true,
          title: 'Add Funds'.txt20(
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        bodyPadding: const EdgeInsets.only(left: 22, right: 21),
        body: Column(
          children: [
            50.sbH,
            AppTextField(
              hintText: 'Amount',
              textInputType: TextInputType.number,
              inputFormatters: [MoneyFormatter()],
              
              onChanged: (value) {},
            ),
            const Spacer(),
            AppBtn.from(
              text: 'Continue',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              bgColor: AppColors.primaryyellow,
              onPressed: () {
                _submit();
              },
            ),
            24.sbH,
          ],
        ));
  }
}

void _submit() {
  $navigate.to(ConfirmTransferPage.route);
}
