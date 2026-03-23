
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/wallet/controller/wallet_controller.dart';
import 'package:stayverse/feature/wallet/model/data/transaction_history_response.dart';
import 'package:stayverse/feature/wallet/view/component/add_funds_buttom_sheet.dart';
import 'package:stayverse/feature/wallet/view/component/transaction_items.dart';
import 'package:stayverse/feature/wallet/view/component/wallet_btn_component.dart';
import 'package:stayverse/feature/wallet/view/page/paystack_page.dart';
import 'package:stayverse/feature/wallet/view/page/withdrawal_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/cutomizeLoading/customized_loading_overlay.dart';
import 'package:stayverse/shared/empty_state.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/lazy_load_scroll_view.dart';
import 'package:stayverse/shared/shrimmer/list_loader.dart';
import 'package:stayverse/shared/skeleton.dart';

class WalletPage extends ConsumerStatefulWidget {
  static const route = '/WalletPage';
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboadController.notifier).refreshUser();
      ref.read(walletController.notifier).getTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: const AppBackButton(),
        title: Text(
          'Wallet',
          style: $styles.text.body.copyWith(
            color: $styles.colors.black,
            fontSize: 20,
          ),
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
                  const Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My balance',
                        style: $styles.text.body.copyWith(
                          color: $styles.colors.greyB9,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(2),
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
                                    fontWeight: FontWeight.w700,
                                    color: $styles.colors.black0C,
                                  ),
                                )
                              : Text(
                                  "****",
                                  style: $styles.text.body.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                    color: $styles.colors.black0C,
                                  ),
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
                                ? Icon(
                                    Icons.visibility,
                                    color: $styles.colors.greyB9,
                                    size: 24,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: $styles.colors.greyB9,
                                    size: 24,
                                  ),
                          ),
                        ],
                      ),
                      const Gap(5),
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
                          const Gap(16),
                          WalletBtnComponent(
                            txt: 'Withdraw',
                            icon: AppIcons.bank_send_sqaure,
                            bgColor: context.themeColors.primaryAccent,
                            onPressed: () {
                              $navigate.to(WithdrawPage.route);
                            },
                          ),
                        ],
                      ),
                    ],
                  ).paddingAll(16),
                  const Gap(10),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: $styles.colors.greyF7,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 20, bottom: 10),
                child: Text(
                  'Activities',
                  style: $styles.text.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: $styles.colors.greyB9,
                  ),
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
                    color: $styles.colors.greyF7,
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
