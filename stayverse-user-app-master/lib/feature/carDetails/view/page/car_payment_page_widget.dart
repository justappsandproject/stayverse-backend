import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/amount_section.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/transfer_details_card.dart';
import 'package:stayverse/feature/carDetails/controller/booking_payment_controller.dart';
import 'package:stayverse/feature/carDetails/model/booking_data.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/wallet/controller/wallet_controller.dart';
import 'package:stayverse/feature/wallet/view/page/paystack_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/cutomizeLoading/customized_loading_overlay.dart';
import 'package:stayverse/shared/skeleton.dart';

import 'car_payment_confirm_page.dart';

class CarPaymentPage extends ConsumerStatefulWidget {
  static const route = '/CarPaymentPage';
  final RideBookingData? bookingData;

  const CarPaymentPage({super.key, this.bookingData});

  @override
  ConsumerState<CarPaymentPage> createState() => _RidePaymentPageState();
}

class _RidePaymentPageState extends ConsumerState<CarPaymentPage> {
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
                      apartmentFee: bookingData?.ridePrice,
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
                      text: "Book Ride",
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

  void _submit(RideBookingData? bookingData) async {
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

  void _processPayment(double fundAmount, RideBookingData bookingData) async {
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

  void _processBooking(RideBookingData bookingData) async {
    CustomizedLoadingOverlay.show(
      context: context,
      message: 'Booking Ride',
    );
    final proceed = await ref
        .read(rideBookingPaymenrController.notifier)
        .bookService(BookingRequest(
          serviceType: ServiceType.rides,
          rideId: bookingData.ride?.id ?? '',
          startDate: bookingData.pickUpDateTime,
          pickupPlaceId: bookingData.pickupPlaceId,
          totalHours: bookingData.totalHours,
          additionalRequest: bookingData.additionalReq,
          securityDetails: bookingData.securityDetails,
        ));
    CustomizedLoadingOverlay.hide();
    if (proceed) {
      $navigate.replaceWithParameters(
        CarBookingConfrim.route,
        args: bookingData,
      );
    }
  }
}
