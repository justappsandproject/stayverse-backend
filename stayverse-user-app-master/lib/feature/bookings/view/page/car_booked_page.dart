import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/bookings/controller/bookings_controller.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/component/booking_info_section.dart';
import 'package:stayverse/feature/bookings/view/component/build_list_item.dart';
import 'package:stayverse/feature/bookings/view/component/cancel_bookings_dialog.dart';
import 'package:stayverse/feature/bookings/view/component/image_carousel.dart';
import 'package:stayverse/feature/bookings/view/component/pick_up_location_container.dart';
import 'package:stayverse/feature/bookings/view/component/ride_description_section.dart';
import 'package:stayverse/feature/bookings/view/component/ride_feature_section.dart';
import 'package:stayverse/feature/bookings/view/component/ride_header_section.dart';
import 'package:stayverse/feature/bookings/view/component/ride_time_line_widget.dart';
import 'package:stayverse/feature/bookings/view/page/leave_a_review_page.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_booking_security_details.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/cancellation_policy.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class CarBookedPage extends ConsumerStatefulWidget {
  static const route = '/CarBookedPage';
  final Booking? data;
  const CarBookedPage({super.key, this.data});

  @override
  ConsumerState<CarBookedPage> createState() => _CarBookedPageState();
}

class _CarBookedPageState extends ConsumerState<CarBookedPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get rideImages {
    final images = widget.data?.ride?.rideImages;
    if (images != null && images.isNotEmpty) {
      return images;
    }
    return List.generate(3, (_) => Constant.defaultApartmentImage);
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.data;
    final isCompleted = booking?.status == BookingStatus.completed.name;

    final bookingStatus = BookingStatus.values.firstWhere(
      (e) => e.name == booking?.status,
      orElse: () => BookingStatus.pending,
    );

    return BrimSkeleton(
      appBar: AppBar(
        leading: const AppBackButton(),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Details',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCarouselSection(
                images: rideImages,
                pageController: _pageController,
                status: widget.data?.status ?? 'Active',
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RideHeaderSection(
                      rideName: widget.data?.ride?.rideName ?? '---',
                      rating: widget.data?.ride?.averageRating ?? 0.0,
                      rideBooking: widget.data!,
                    ),
                    const Gap(20),
                    BookingInfoSection(
                        totalPrice: widget.data?.totalPrice ?? 0.0,
                        startDate: widget.data?.startDate,
                        endDate: widget.data?.endDate),
                    const Gap(20),
                    RideDescriptionSection(
                      description: widget.data?.ride?.rideDescription ?? "--",
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailItem(
                          icon: Icons.people,
                          text:
                              '${widget.data?.ride?.maxPassengers ?? 'N/A'} Passengers',
                        ),
                        DetailItem(
                          icon: Icons.color_lens,
                          text: widget.data?.ride?.color ?? 'N/A',
                        ),
                        DetailItem(
                          icon: Icons.directions_car,
                          text: widget.data?.ride?.plateNumber ?? 'N/A',
                        ),
                      ],
                    ),
                    const Gap(30),
                    const HorizontalLine(),
                    const Gap(30),
                    RideTimeLineWidget(
                      checkedInString: 'Pick up',
                      checkedOutString: 'Drop off',
                      checkedIn: widget.data?.startDate,
                      checkedOut: widget.data?.endDate,
                      isCompleted: false,
                    ),
                    const Gap(30),
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
                    PickUpLocationContainer(
                        pickupAddress: widget.data?.pickupAddress),
                    const Gap(30),
                    RideBookingSecurityDetails(
                      isSelectable: false,
                      preselected: widget.data?.securityDetails,
                    ),
                    const Gap(30),
                    Text(
                      'Additional Request',
                      style: $styles.text.h4.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const Gap(12),
                    Text(
                      widget.data?.notes ?? 'No additional requests',
                      style: $styles.text.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF898A8D),
                      ),
                    ),
                    const Gap(20),
                    const HorizontalLine(),
                    const Gap(20),
                    RideFeaturesSection(
                      features: widget.data?.ride?.features ?? [],
                    ),
                    const Gap(20),
                    const HorizontalLine(),
                    const Gap(20),
                    RulesSection(
                      rules: widget.data?.ride?.rules ?? '',
                    ),
                    const Gap(20),
                    const CancellationPolicySection(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBtn.from(
                  text: isCompleted ? 'Leave a Review' : 'Cancel Booking',
                  bgColor: Colors.black,
                  expand: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (isCompleted) {
                      $navigate.toWithParameters(
                        LeaveAReviewPage.route,
                        args: LeaveAReviewArgs(
                          serviceType: ServiceType.rides.apiPoint,
                          serviceId: widget.data?.ride?.id ?? '',
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => CancelBookingsDialog(onConfirm: ()  async {
                          final proceed = await ref
                              .read(bookingController.notifier)
                              .cancelBooking(
                                  booking?.bookingId ?? '', bookingStatus);
                          if (proceed) {
                            $navigate.back();
                          }
                        }),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalServicesSection extends StatelessWidget {
  final bool securityOfficialEnabled;
  final bool airportPickupEnabled;

  const AdditionalServicesSection({
    super.key,
    required this.securityOfficialEnabled,
    required this.airportPickupEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildListItem(
          'Security Official',
          securityOfficialEnabled,
        ),
        buildListItem(
          'Airport Pickup & Dropoff',
          airportPickupEnabled,
        ),
      ],
    );
  }
}

class RulesSection extends StatelessWidget {
  final String rules;

  const RulesSection({
    super.key,
    required this.rules,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rules',
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(10),
        Text(
          rules,
          style: $styles.text.body.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
