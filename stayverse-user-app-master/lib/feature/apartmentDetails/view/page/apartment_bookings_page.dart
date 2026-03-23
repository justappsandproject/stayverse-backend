import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/apartmentDetails/controller/aparment_details_controller.dart';
import 'package:stayverse/feature/apartmentDetails/controller/apartment_bookings_controller.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_data.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_images.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/calender/range_calender.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

import 'apartment_payment_page.dart';

class ApartmentBookingsPage extends ConsumerStatefulWidget {
  static const route = '/ApartmentBookingsPage';
  final Apartment? apartment;

  const ApartmentBookingsPage({super.key, required this.apartment});

  @override
  ConsumerState<ApartmentBookingsPage> createState() =>
      _ApartmentBookingsPagePageState();
}

class _ApartmentBookingsPagePageState
    extends ConsumerState<ApartmentBookingsPage> {
  final PageController _pageController = PageController();
  late List<String> apartmentImages;

  @override
  void initState() {
    super.initState();
    _populate();
  }

  void _populate() {
    final apartment = widget.apartment;
    apartmentImages = apartment?.apartmentImages?.isNotEmpty == true
        ? apartment!.apartmentImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
  }

  @override
  Widget build(BuildContext context) {
    final bookingsController = ref.watch(apartmentBookingsController);
    final apartment = widget.apartment;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    ApartmentImages(
                        pageController: _pageController,
                        apartmentImages: apartmentImages),
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
                    apartment?.apartmentName ?? 'Unknown Apartment',
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
                            serviceType: ServiceType.apartment.apiPoint,
                            serviceId: apartment?.id ?? '',
                          ));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.black, size: 20),
                        Text(
                          (apartment?.averageRating ?? '0.0').toString(),
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
                    MoneyServiceV2.formatNaira(apartment?.pricePerDay ?? 0,
                        decimalDigits: 0),
                    style: $styles.text.body.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '/day',
                    style: $styles.text.body.copyWith(
                      fontSize: 20,
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
              const Gap(14),
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stay Duration',
                            style: $styles.text.title1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${DateTimeService.format(bookingsController.dateRange?.start, format: 'd MMM')} - ${DateTimeService.format(bookingsController.dateRange?.end, format: 'd MMM')}',
                            style: $styles.text.title1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Apartment Price',
                            style: $styles.text.title1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            MoneyServiceV2.formatNaira(
                                bookingsController.apartmentPrice,
                                decimalDigits: 0),
                            style: $styles.text.title1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(10),
                  RangeCalendar(
                    onRangeSelected: (DateTimeRange range) {
                      ref
                          .read(apartmentBookingsController.notifier)
                          .updateBookingDates(
                              range, apartment?.pricePerDay ?? 0);
                    },
                    height: 340,
                    showOutsideDays: true,
                    rangeColor: context.color.primary,
                    selectedColor: context.color.primary,
                    blockPastDays: true,
                    blockedColor: Colors.grey.shade600,
                    blockedDates: ref
                        .watch(
                          apartmentDetailsController,
                        )
                        .bookedDays
                        .toList(),
                  )
                ],
              ),
              const Gap(10),
              AppBtn.from(
                text: 'Confirm Bookings',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onPressed: () {
                  _submit(apartment);
                },
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(Apartment? apartment) {
    final controller = ref.watch(apartmentBookingsController);

    if (controller.dateRange == null) {
      BrimToast.showError('Please select a booking date',
          title: 'Booking Date');
      return;
    }

    final totalPrice =
        (controller.apartmentPrice ?? 0) + (apartment?.cautionFee ?? 0);

    final bookingData = BookingData(
      apartment: apartment,
      dateRange: controller.dateRange!,
      totalPrice: totalPrice,
      apartmentPrice: controller.apartmentPrice ?? 0,
      cautionFee: apartment?.cautionFee ?? 0,
    );

    $navigate.toWithParameters(
      ApartmentPaymentPage.route,
      args: bookingData,
    );
  }
}
