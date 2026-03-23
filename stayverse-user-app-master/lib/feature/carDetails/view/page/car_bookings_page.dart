import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/carDetails/controller/ride_booking_controller.dart';
import 'package:stayverse/feature/carDetails/model/booking_data.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_booking_security_details.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_images.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_pick_up_date_and_time.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_pick_up_location_field.dart';
import 'package:stayverse/feature/carDetails/view/page/car_payment_page_widget.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class CarBookingsPage extends ConsumerStatefulWidget {
  static const route = '/CarBookingPage';
  final Ride? ride;

  const CarBookingsPage({super.key, required this.ride});

  @override
  ConsumerState<CarBookingsPage> createState() => _CarBookingsPagePageState();
}

class _CarBookingsPagePageState extends ConsumerState<CarBookingsPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  late List<String> apartmentImages;
  final _pickUpController = TextEditingController();
  final _totalHoursController = TextEditingController();
  final _additionalRequestController = TextEditingController();

  String? pickUpPlaceId;
  String? pickUpAddress;

  DateTime? pickUpDateTime;

  List<String> selectedSecurity = [];

  @override
  void initState() {
    super.initState();
    _populate();
  }

  @override
  void dispose() {
    _pickUpController.dispose();
    _totalHoursController.dispose();
    super.dispose();
  }

  void _populate() {
    final ride = widget.ride;
    apartmentImages = ride?.rideImages?.isNotEmpty == true
        ? ride!.rideImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
  }

  @override
  Widget build(BuildContext context) {
    //final bookingsController = ref.watch(rideBookingsController);
    final ride = widget.ride;

    return BrimSkeleton(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Bookings',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      RideImages(
                          pageController: _pageController,
                          rideImages: apartmentImages),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: apartmentImages.length,
                            effect: WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: context.color.primary,
                              dotColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ride?.rideName ?? 'Unknown Rides',
                      style: $styles.text.title1.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        $navigate.toWithParameters(ReviewsPage.route,
                            args: LeaveAReviewArgs(
                              serviceType: ServiceType.rides.apiPoint,
                              serviceId: ride?.id ?? '',
                            ));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.black, size: 20),
                          Text(
                            (ride?.averageRating ?? '0.0').toString(),
                            style: $styles.text.bodyBold.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.85,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    Text(
                      MoneyServiceV2.formatNaira(ride?.pricePerHour ?? 0,
                          decimalDigits: 0),
                      style: $styles.text.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '/hr',
                      style: $styles.text.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const HorizontalLine(
                  color: Color(0xFFF7F7F7),
                ),
                const Gap(20),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick-Up Location',
                          style: $styles.text.h4.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const Gap(10),
                        RidePickUpLocationField(
                          pickUpController: _pickUpController,
                          onLocationSelected: (placeId, address) {
                            pickUpPlaceId = placeId;
                            pickUpAddress = address;
                          },
                        ),
                        const Gap(20),
                        Text(
                          'Pick-Up Date & Time',
                          style: $styles.text.h4.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const Gap(10),
                        RidePickUpDateAndTime(
                          onDateTimeSelected: (dt) {
                            pickUpDateTime = dt;
                          },
                        ),
                        const Gap(20),
                        AppTextField(
                          title: "Total hours",
                          hintText: 'Enter Hours',
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            MoneyFormatter()
                          ],
                          controller: _totalHoursController,
                          borderRadius: BorderRadius.circular(12),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          disableBorderColor: const Color(0xFFEAEAEA),
                          enabledBorderColor: const Color(0xFFEAEAEA),
                          focusedBorderColor: const Color(0XFFAAADB7),
                          validator: (value) {
                            final hours = int.tryParse(value ?? '') ?? 0;
                            if (hours < 1) {
                              return 'Minimum booking is 1 hour';
                            }
                            return null;
                          },
                        ),
                        const Gap(20),
                        RideBookingSecurityDetails(
                          isSelectable: true,
                          onChanged: (list) {
                            selectedSecurity = list;
                          },
                        ),
                        const Gap(20),
                        AppTextField(
                          title: "Additional Request",
                          hintText: 'Enter Request',
                          textInputType: TextInputType.text,
                          controller: _additionalRequestController,
                          textInputAction: TextInputAction.done,
                          borderRadius: BorderRadius.circular(12),
                          minLines: 4,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          disableBorderColor: const Color(0xFFEAEAEA),
                          enabledBorderColor: const Color(0xFFEAEAEA),
                          focusedBorderColor: const Color(0XFFAAADB7),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(40),
                AppBtn.from(
                  text: 'Confirm Bookings',
                  expand: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _submit(ride);
                  },
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(Ride? ride) {
    final controller = ref.watch(rideBookingsController.notifier);

    if (pickUpPlaceId == null) {
      BrimToast.showError('Please enter a pick-up location',
          title: 'Pick-Up Location');
      return;
    }
    if (pickUpDateTime == null) {
      BrimToast.showError('Please select a pick-up date & time',
          title: 'Pick-Up Date & Time');
      return;
    }
    if (_totalHoursController.text.isEmpty) {
      BrimToast.showError('Please enter a total hours', title: 'Total Hours');
      return;
    }

    final totalHours = _totalHoursController.text.trim().toIntOrNull() ?? 0;

    controller.calculateTotalPrice(
      startDateTime: pickUpDateTime!,
      totalHours: totalHours,
      pricePerHour: ride?.pricePerHour ?? 0,
    );

// 🔥 Read UPDATED state
    final updatedState = ref.read(rideBookingsController);

    final totalPrice = (updatedState.ridePrice ?? 0) + (ride?.cautionFee ?? 0);

    final bookingData = RideBookingData(
      ride: ride,
      pickupPlaceId: pickUpPlaceId ?? '',
      pickUpDateTime: pickUpDateTime,
      totalHours: totalHours,
      securityDetails: selectedSecurity,
      additionalReq: _additionalRequestController.text.trim(),
      totalPrice: totalPrice,
      ridePrice: updatedState.ridePrice ?? 0,
      cautionFee: ride?.cautionFee ?? 0,
    );

    $navigate.toWithParameters(
      CarPaymentPage.route,
      args: bookingData,
    );
  }
}


 // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Stay Duration',
                      //       style: $styles.text.title1.copyWith(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Text(
                      //       '${DateTimeService.format(bookingsController.dateRange?.start, format: 'd MMM')} - ${DateTimeService.format(bookingsController.dateRange?.end, format: 'd MMM')}',
                      //       style: $styles.text.title1.copyWith(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Car Price',
                      //       style: $styles.text.title1.copyWith(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Text(
                      //       MoneyServiceV2.formatNaira(
                      //           bookingsController.apartmentPrice,
                      //           decimalDigits: 0),
                      //       style: $styles.text.title1.copyWith(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                  //      const Gap(10),
                  // RangeCalendar(
                  //   onRangeSelected: (DateTimeRange range) {
                  //     ref
                  //         .read(rideBookingsController.notifier)
                  //         .updateBookingDates(range, ride?.pricePerDay ?? 0);
                  //   },
                  //   height: 340,
                  //   showOutsideDays: true,
                  //   rangeColor: context.color.primary,
                  //   selectedColor: context.color.primary,
                  //   blockPastDays: true,
                  //   blockedColor: Colors.grey.shade600,
                  //   blockedDates:
                  //       ref.watch(carDetailsController).bookedDays.toList(),
                  // )