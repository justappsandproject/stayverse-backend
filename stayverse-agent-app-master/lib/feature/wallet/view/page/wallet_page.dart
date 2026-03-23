import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/wallet/model/data/transaction_history_response.dart';
import 'package:stayvers_agent/feature/wallet/controller/wallet_controller.dart';
import 'package:stayvers_agent/feature/wallet/view/component/add_funds_buttom_sheet.dart';
import 'package:stayvers_agent/feature/wallet/view/component/transaction_items.dart';
import 'package:stayvers_agent/feature/wallet/view/component/wallet_btn_component.dart';
import 'package:stayvers_agent/feature/wallet/view/page/paystack_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/withdraw_page.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/cutomizeLoading/customized_loading_overlay.dart';
import 'package:stayvers_agent/shared/empty_state.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/shrimmer.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(walletController.notifier).getTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: 'Wallet'.txt20(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      bodyPadding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(walletController.notifier).getTransactionHistory(),
            ref.read(dashboadController.notifier).refreshUser(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.sbH,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'My balance'.txt14(
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyB9,
                      ),
                      2.sbH,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ref.watch(walletController
                                  .select((state) => state.showBalance))
                              ? Text(
                                  ref.watch(dashboadController.select((state) =>
                                      MoneyServiceV2.formatNaira(
                                          state.user?.balance?.toDouble() ??
                                              0))),
                                  style: $styles.text.body.copyWith(
                                    fontSize: 38,
                                    fontFamily: Constant.inter,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black0C,
                                  ),
                                )
                              : "****".txt(
                                  size: 38,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black0C,
                                ),
                          const Gap(12),
                          AppBtn.basic(
                            semanticLabel: 'toggle balance',
                            onPressed: () {
                              ref
                                  .read(walletController.notifier)
                                  .toggleBalance();
                            },
                            child: ref.watch(walletController
                                    .select((state) => state.showBalance))
                                ? const Icon(
                                    Icons.visibility,
                                    color: AppColors.greyB9,
                                    size: 24,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: AppColors.greyB9,
                                    size: 24,
                                  ),
                          ),
                        ],
                      ),
                      5.sbH,
                      Row(
                        children: [
                          WalletBtnComponent(
                            txt: 'Add Funds',
                            icon: AppIcons.add_solid,
                            onPressed: () {
                              AddFundsBottomSheet.show(context, (value) {
                                onAddFunds(value ?? '');
                              });
                            },
                          ),
                          16.sbW,
                          WalletBtnComponent(
                            txt: 'Withdraw',
                            icon: AppIcons.bank_send_sqaure,
                            bgColor: AppColors.primaryyellow,
                            onPressed: () {
                              $navigate.to(WithdrawPage.route);
                            },
                          ),
                        ],
                      ),
                    ],
                  ).paddingAll(16),
                  10.sbH,
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: AppColors.greyF7,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 20, bottom: 10),
                child: 'Activities'.txt14(
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyB9,
                ),
              ),
            ),
            ItemView(
              loader:
                  const SliverToBoxAdapter(child: ListLoader(itemLength: 10)),
              emptyState: const EmptyState.sliver(
                message: 'No Transactions',
              ),
              items: ref.watch(
                  walletController.select((state) => state.transactions)),
              isAdsLoading: ref.watch(walletController
                  .select((state) => state.isLoadingTransactions)),
              itemViewBuilder: (BuildContext context, Widget? child,
                  List<Transactions> items) {
                return SliverFillRemaining(
                  child: Container(
                    color: AppColors.greyF7,
                    child: LazyLoadScrollView(
                      onEndOfPage: () async {
                        await ref
                            .read(walletController.notifier)
                            .getTransactionHistory(loadMore: true);
                      },
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return TransactionItems(transaction: items[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void onAddFunds(String amount) async {
    final amountDouble = MoneyServiceV2.convertMoneyToDouble(amount);
    if (amountDouble == null) return;
    CustomizedLoadingOverlay.show(context: context);
    final response =
        await ref.read(walletController.notifier).fundWallet(amountDouble);
    CustomizedLoadingOverlay.hide();
    if (response?.data?.authorizationUrl == null) {
      BrimToast.showError('Please try payment again');
      return;
    }
    await $navigate.toWithParameters(PayStackPage.route,
        args: response?.data?.authorizationUrl ?? '');

    await ref
        .read(walletController.notifier)
        .verifyPayment(response?.data?.reference ?? '');
    Future.wait([
      ref.read(dashboadController.notifier).refreshUser(),
      ref.read(walletController.notifier).getTransactionHistory(),
    ]);
  }
}
