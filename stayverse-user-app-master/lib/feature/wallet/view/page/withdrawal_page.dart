import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/wallet/controller/wallet_controller.dart';
import 'package:stayverse/feature/wallet/controller/withdrawal_controller.dart';
import 'package:stayverse/feature/wallet/model/data/verify_bank_request.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_request.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_success_data.dart';
import 'package:stayverse/feature/wallet/view/component/bank_selector.dart';
import 'package:stayverse/feature/wallet/view/component/enter_password_buttom_sheet.dart';
import 'package:stayverse/feature/wallet/view/component/selected_bank.dart';
import 'package:stayverse/feature/wallet/view/page/withdrawal_successful_page.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';


class WithdrawPage extends ConsumerStatefulWidget {
  static const route = '/WithdrawPage';
  const WithdrawPage({super.key});

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumber = TextEditingController();
  final _amount = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _accountNumber.dispose();
    _amount.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalController);
    return BrimSkeleton(
      isBusy: state.isBusy,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Withdraw to bank',
          style: $styles.text.body.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: $styles.colors.black,
          ),
        ),
        leading: AppBtn.basic(
          semanticLabel: 'back',
          onPressed: () {
            $navigate.back();
          },
          child: Icon(Icons.arrow_back, size: 24.sp, color: $styles.colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),
                  AppBtn.basic(
                    onPressed: () {
                      BankSelectionBottomSheet.show(context, (bank) {
                        ref
                            .read(withdrawalController.notifier)
                            .selectBank(bank);
                        _verifyAccountName(
                          _accountNumber.text.toString().trim(),
                        );
                      });
                    },
                    semanticLabel: 'banks',
                    child: SelectedBank(
                      data: ref.watch(withdrawalController
                          .select((value) => value.selectedBank)),
                    ),
                  ),
                  const Gap(20),
                  AppTextField(
                      hintText: 'Account Number',
                      textInputType: TextInputType.number,
                      controller: _accountNumber,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: (value) =>
                          Validator.validateAccountNumber(value),
                      onChanged: (number) {
                        _verifyAccountName(number);
                      }),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: ref.watch(withdrawalController
                            .select((value) => value.isFetchingName))
                        ? LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(100),
                            minHeight: 2,
                            valueColor: AlwaysStoppedAnimation(
                                context.themeColors.primaryAccent),
                          ).paddingOnly(top: 10)
                        : isEmpty(ref.watch(withdrawalController
                                .select((value) => value.accountName ?? '')))
                            ? const SizedBox()
                            : Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        ref.watch(withdrawalController.select(
                                            (value) =>
                                                value.accountName ?? '')),
                                        textAlign: TextAlign.center,
                                        style: $styles.text.bodySmall.copyWith(
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                            color: $styles.colors.black,
                                            fontSize: 14.sp)))
                                .paddingOnly(top: 10),
                  ),
                  const Gap(20),
                  AppTextField(
                    hintText: 'Enter Amount',
                    textInputType: TextInputType.number,
                    controller: _amount,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [MoneyFormatter()],
                    validator: (value) => Validator.validateMoney(
                      value,
                      maxAllowed: 1000000,
                      minAllowed: 1000,
                    ),
                    prefixWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₦',
                          style: $styles.text.body.copyWith(
                            color: $styles.colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
            AppBtn.from(
              text: 'Confirm',
              expand: true,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: $styles.colors.black,
              ),
              bgColor: context.themeColors.primaryAccent,
              onPressed: () {
                _submit();
              },
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  _verifyAccountName(String? accountNumber, {bool showWarning = false}) {
    if (isEmpty(accountNumber)) {
      return;
    }
    final valid = Validator.isNigeriaAccountNumberValid(accountNumber);

    if (valid) {
      final selectedBank = ref.read(withdrawalController).selectedBank;
      if (selectedBank == null) {
        BrimToast.showError('Please Select a Bank');
        return;
      }
      ref.read(withdrawalController.notifier).verifyBankAccount(
          VerifyBankRequest(
              accountNumber: accountNumber!, bankCode: selectedBank.code));
    } else {
      if (showWarning) {
        BrimToast.showHint('Please Check Account Number');
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final selectedBank =
          ref.read(withdrawalController.select((value) => value.selectedBank));

      final accountName =
          ref.read(withdrawalController.select((value) => value.accountName));

      if (selectedBank == null) {
        BrimToast.showError('Select Bank', title: 'No Bank Selected');
        return;
      }

      if (isEmpty(accountName)) {
        BrimToast.showError('Enter A Valid Account Number And Bank',
            title: 'Account Name Not Found');
        return;
      }
      EnterPasswordBottomSheet.show(context, (password) {
        _processWithWithdrawal(password);
      });
    }
  }

  void _processWithWithdrawal(String? password) async {
    final selectedBank =
        ref.read(withdrawalController.select((value) => value.selectedBank));
    final accountName =
        ref.read(withdrawalController.select((value) => value.accountName));

    final amount =
        MoneyServiceV2.convertMoneyToDouble(_amount.text.toString().trim());
    final accountNumber = _accountNumber.text.toString().trim();
    final process = await ref
        .read(withdrawalController.notifier)
        .withdraw(WithdrawalRequest(
          fullName: accountName,
          amount: amount,
          accountNumber: accountNumber,
          bankCode: selectedBank?.code,
          password: password!,
        ));
    if (process) {
      ref.read(dashboadController.notifier).refreshUser();
      ref.read(walletController.notifier).getTransactionHistory();
      $navigate.replaceWithParameters(WithdrawalSuccessfulPage.route,
          args: WithdrawalSuccessData(
            amount: amount,
            bankName: selectedBank?.name,
            accountName: accountName,
            accountNumber: accountNumber,
            timestamp: DateTime.now(),
            fee: 100,
          ));
    }
  }
}
