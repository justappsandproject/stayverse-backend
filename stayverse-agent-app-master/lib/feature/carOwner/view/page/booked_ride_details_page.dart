import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/cancel_bookings_dialog.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_amenity_post_controller.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/car_map_view.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_images.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_security_details.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_time_line_widget.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/pending_ride_details.dart';
import 'package:stayvers_agent/feature/discover/controller/apartment_bookings_controller.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';
import 'package:stayvers_agent/feature/discover/view/component/guest_info_card.dart';
import 'package:stayvers_agent/feature/discover/view/component/payment_info_card.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../component/ride_amenities_widget.dart';

class BookedRideDetailsPage extends ConsumerStatefulWidget {
  static const route = '/BookedRideDetailsPage';
  const BookedRideDetailsPage({
    super.key,
    this.isCompleted = false,
    this.rideDetails,
  });
  final bool? isCompleted;
  final Booking? rideDetails;

  @override
  ConsumerState<BookedRideDetailsPage> createState() =>
      _BookedRideDetailsPageState();
}

class _BookedRideDetailsPageState extends ConsumerState<BookedRideDetailsPage> {
  final PageController _pageController = PageController();
  late List<String> rideImages;

  late List<String> rideamenities;

  @override
  void initState() {
    _populate();
    super.initState();
  }

  void _populate() {
    final rideDetails = widget.rideDetails?.ride;
    rideImages = rideDetails?.rideImages?.isNotEmpty == true
        ? rideDetails!.rideImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    rideamenities = rideDetails?.features ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(rideAmenityProvider);
    return BrimSkeleton(
      isBusy: ref.watch(bookingController).isBusy,
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: 'Details'.txt20(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RideImages(
              pageController: _pageController,
              rideImages: rideImages,
            ),
            12.sbH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.rideDetails?.ride?.rideName ?? 'Unnamed Ride').txt20(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                GestureDetector(
                  onTap: () {
                    $navigate.toWithParameters(
                      ReviewsPage.route,
                      args: ReviewArgs(
                        serviceType: ServiceType.carOwner.id,
                        serviceId: widget.rideDetails?.ride?.id ?? '',
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.black, size: 17),
                      2.sbW,
                      Text(
                        '${widget.rideDetails?.ride?.averageRating ?? '0.0'}',
                        style: $styles.text.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                          letterSpacing: 0.85,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  widget.rideDetails?.ride?.pricePerHour != null
                      ? MoneyServiceV2.formatNaira(
                          widget.rideDetails?.ride?.pricePerHour?.toDouble() ??
                              0,
                          decimalDigits: 0)
                      : '₦--',
                  style: $styles.text.body.copyWith(
                    fontSize: 16,
                    fontFamily: Constant.inter,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                '/hr'.txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8D,
                ),
              ],
            ),
            24.sbH,
            PaymentInfoCard(booking: widget.rideDetails),
            30.sbH,
            // 'Scheduled Date'.txt14(
            //   fontWeight: FontWeight.w500,
            //   color: AppColors.black,
            // ),
            // 17.sbH,
            // CustomCalendar(
            //   startDate: widget.rideDetails?.startDate,
            //   endDate: widget.rideDetails?.endDate,
            // ),
            // 25.sbH,

            'Ride Details'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            12.sbH,
            (widget.rideDetails?.ride?.rideDescription ??
                    'No details available')
                .txt(
              size: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey8D,
            ),
            30.sbH,
            RideTimeLineWidget(
              checkedInString:
                  widget.isCompleted == true ? 'Picked Up' : 'Pick Up',
              checkedOutString:
                  widget.isCompleted == true ? 'Dropped Off' : 'Drop Off',
              checkedIn: widget.rideDetails?.startDate,
              checkedOut: widget.rideDetails?.endDate,
              isCompleted: widget.isCompleted ?? false,
            ),
            30.sbH,
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
            PickUpLocationWidget(
                pickupAddress: widget.rideDetails?.pickupAddress),
            30.sbH,
            RideSecurityDetails(
                securityDetails: widget.rideDetails?.securityDetails),
            30.sbH,
            'Additional Request'
                .txt14(fontWeight: FontWeight.w500, color: AppColors.black),
            12.sbH,
            (widget.rideDetails?.notes ?? 'No additional requests').txt(
              size: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey8D,
            ),
            30.sbH,
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: AppColors.greyF7))),
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RideAmenitiesWidget(
                    selectedFeatureNames: rideamenities,
                    allAvailableAmenities: allAmenities,
                  ),
                  15.sbH,
                  const Divider(
                    color: AppColors.greyF7,
                  ),
                  18.sbH,
                  GuestInfoCard(user: widget.rideDetails!.user!),
                  15.sbH,
                  const Divider(
                    color: AppColors.greyF7,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: 'Location'.txt14(
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.grey8D,
                          size: 12,
                        ),
                        Expanded(
                          child: (widget.rideDetails?.ride?.address ?? '--').txt(
                            size: 12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey8D,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.rideDetails?.ride?.location?.coordinates != null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CarMapView(
                                    latLng: widget
                                        .rideDetails?.ride?.location?.latLng,
                                    address:
                                        widget.rideDetails?.ride?.address ?? '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  23.sbH,
                  const Divider(
                    color: AppColors.greyF7,
                  ),
                  'House Rules'.txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  10.sbH,
                  (widget.rideDetails?.ride?.rules ?? 'No rules available').txt(
                    size: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                  19.sbH,
                  const Divider(
                    color: AppColors.greyF7,
                  ),
                  17.sbH,
                  'Cancellation Policy'.txt14(
                      fontWeight: FontWeight.w500, color: AppColors.black),
                  12.sbH,
                  'You may cancel your booking at any time. For a full refund, cancellations must be made at least 24 hours before the scheduled start time. Cancellations made within 24 hours are non-refundable. In case of emergencies, please contact our support team for assistance.'
                      .txt(
                    size: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                  if (widget.isCompleted == false) ...[
                    53.sbH,
                    AppBtn.from(
                      text: 'Cancel Booking',
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                      bgColor: AppColors.black,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => CancelBookingsDialog(onConfirm: () {
                            $navigate.back();
                            _submit(status: BookingStatus.rejected);
                          }),
                        );
                      },
                    ),
                  ],
                  21.sbH,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit({required BookingStatus status}) async {
    if (widget.rideDetails?.id == null) return;

    final controller = ref.read(bookingController.notifier);

    final request = BookingStatusRequest(
      bookingId: widget.rideDetails!.id!,
      status: status,
    );

    bool success = false;

    if (status == BookingStatus.rejected) {
      success = await controller.declineBooking(request);
    }

    if (success && mounted) {
      $navigate.back();
    }
  }
}
