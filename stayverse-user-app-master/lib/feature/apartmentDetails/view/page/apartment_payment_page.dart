// File: apartment_payment_page.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/controller/booking_payment_controller.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_data.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/amount_section.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/transfer_details_card.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/wallet/controller/wallet_controller.dart';
import 'package:stayverse/feature/wallet/view/page/paystack_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/cutomizeLoading/customized_loading_overlay.dart';
import 'package:stayverse/shared/skeleton.dart';

import 'booking_confrimed.dart';

class ApartmentPaymentPage extends ConsumerStatefulWidget {
  static const route = '/ApartmentPaymentPage';
  final BookingData? bookingData;

  const ApartmentPaymentPage({super.key, this.bookingData});

  @override
  ConsumerState<ApartmentPaymentPage> createState() =>
      _ApartmentPaymentPageState();
}

class _ApartmentPaymentPageState extends ConsumerState<ApartmentPaymentPage> {
  @override
  Widget build(BuildContext context) {
    final bookingData = widget.bookingData;

    return BrimSkeleton(
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      appBar: AppBar(
        backgroundColor: context.color.primary.withValues(alpha: 0.1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text(
          'Confirm Payment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 0.2.sh,
            decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.2.sh),
                  bottomRight: Radius.circular(0.2.sh),
                )),
            child: Center(child: Image.asset(AppAsset.bigSmile)),
          ),
          const Gap(15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AmountDetailsSection(amount: bookingData?.totalPrice),
                    const Gap(15),
                    TransferSection(
                      apartmentFee: bookingData?.apartmentPrice,
                      cautionFee: bookingData?.cautionFee,
                    ),
                    const Gap(25),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        border: Border.all(color: const Color(0xFFF4F4F4)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Text(
                        'Note: Caution Fees would be refunded to your wallet 24hrs after checking out.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const Gap(25),
                    AppBtn.from(
                      text: "Book Apartment",
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _submit(bookingData);
                      },
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BookingData? bookingData) async {
    if (bookingData == null) return;

    final balance = ref.read(dashboadController).user?.balance;

    if (!MoneyServiceV2.isBalanceEnough(
        balance: balance!, amount: bookingData.totalPrice)) {
      final amountRequired = bookingData.totalPrice - balance;
      _processPayment(amountRequired, bookingData);
      return;
    }
    _processBooking(bookingData);
  }

  void _processPayment(double fundAmount, BookingData bookingData) async {
    CustomizedLoadingOverlay.show(
        context: context, message: 'Processing payment...');

    final response =
        await ref.read(walletController.notifier).fundWallet(fundAmount);

    if (response?.data?.authorizationUrl == null) {
      BrimToast.showError('Please try payment again');
      CustomizedLoadingOverlay.hide();
      return;
    }
    CustomizedLoadingOverlay.hide();

    final result = await $navigate.toWithParameters(PayStackPage.route,
        args: response?.data?.authorizationUrl ?? '');

    if (result == true) {
      if (mounted) {
        CustomizedLoadingOverlay.show(
            context: context, message: 'Verifying payment...');
      }
      await ref
          .read(walletController.notifier)
          .verifyPayment(response?.data?.reference ?? '');

      await Future.wait([
        ref.read(dashboadController.notifier).refreshUser(),
        ref.read(walletController.notifier).getTransactionHistory(),
      ]);
      CustomizedLoadingOverlay.hide();

      _processBooking(bookingData);
    }
  }

  void _processBooking(BookingData bookingData) async {
    CustomizedLoadingOverlay.show(
      context: context,
      message: 'Booking Apartment',
    );
    final proceed = await ref
        .read(bookingPaymenrController.notifier)
        .bookService(BookingRequest(
          serviceType: ServiceType.apartment,
          apartmentId: bookingData.apartment?.id ?? '',
          startDate: bookingData.dateRange.start,
          endDate: bookingData.dateRange.end,
          totalAmout: bookingData.totalPrice,
        ));
    CustomizedLoadingOverlay.hide();

    if (proceed) {
      $navigate.replaceWithParameters(
        ApartmentBookingConfrim.route,
        args: bookingData,
      );
    }
  }
}
