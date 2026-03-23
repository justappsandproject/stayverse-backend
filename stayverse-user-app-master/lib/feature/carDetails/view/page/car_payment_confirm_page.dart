import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/booking_amount.dart';
import 'package:stayverse/feature/carDetails/model/booking_data.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_transfer_break_down.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class CarBookingConfrim extends StatefulWidget {
  static const route = '/CarBookingConfrim';

  final RideBookingData? bookingData;
  const CarBookingConfrim({super.key, this.bookingData});

  @override
  State<CarBookingConfrim> createState() => _CarBookingConfrimState();
}

class _CarBookingConfrimState extends State<CarBookingConfrim> {
  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      bodyPadding: EdgeInsets.zero,
      appBar: AppBar(
        backgroundColor: context.color.primary.withValues(alpha: 0.1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: AppBackButton(
          onBack: () {
            $navigate.popUntil(3);
          },
        ),
        title: const Text(
          'Booking Confirmed',
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
          const Gap(10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(30),
                    BookingAmountSection(
                      name: widget.bookingData?.ride?.rideName ?? '',
                    ),
                    const Gap(20),
                    RideTransferBreakDown(
                        pickUpDateTime: widget.bookingData?.pickUpDateTime,
                        pickUpLocation: widget.bookingData?.ride?.address,
                        totalPrice: widget.bookingData?.totalPrice ?? 0,
                        hostName: widget.bookingData?.ride?.agent?.user?.firstname),
                    const Gap(20),
                    AppBtn.from(
                      text: "Continue Search",
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        $navigate.popUntil(3);
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
}
