import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/preview_amenities_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/apartment_image.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/cancel_bookings_dialog.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/preview_amenity_widget.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/car_map_view.dart';
import 'package:stayvers_agent/feature/discover/controller/apartment_bookings_controller.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';
import 'package:stayvers_agent/feature/discover/view/component/custom_calender_component.dart';
import 'package:stayvers_agent/feature/discover/view/component/guest_info_card.dart';
import 'package:stayvers_agent/feature/discover/view/component/payment_info_card.dart';
import 'package:stayvers_agent/feature/discover/view/component/timeline_widget.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../component/apartment_info_container.dart';

class BookedApartmentDetailsPage extends ConsumerStatefulWidget {
  static const route = '/BookedApartmentDetailsPage';
  const BookedApartmentDetailsPage({
    super.key,
    this.isCompleted = false,
    this.apartmentDetails,
  });
  final bool? isCompleted;
  final Booking? apartmentDetails;

  @override
  ConsumerState<BookedApartmentDetailsPage> createState() =>
      _BookedApartmentDetailsPageState();
}

class _BookedApartmentDetailsPageState
    extends ConsumerState<BookedApartmentDetailsPage> {
  final PageController _pageController = PageController();
  late List<String> apartmentImages;

  late List<String> apartmentamenities;

  @override
  void initState() {
    _populate();
    super.initState();
  }

  void _populate() {
    final apartmentDetails = widget.apartmentDetails?.apartment;
    apartmentImages = apartmentDetails?.apartmentImages?.isNotEmpty == true
        ? apartmentDetails!.apartmentImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    apartmentamenities = apartmentDetails?.amenities ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(amenityProvider);
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
            ApartmentImages(
              pageController: _pageController,
              apartmentImages: apartmentImages,
            ),
            12.sbH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.apartmentDetails?.apartment?.apartmentName ??
                        'Unnamed Apartment')
                    .txt20(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                GestureDetector(
                  onTap: () {
                    $navigate.toWithParameters(
                      ReviewsPage.route,
                      args: ReviewArgs(
                        serviceType: ServiceType.apartmentOwner.id,
                        serviceId: widget.apartmentDetails?.id ?? '',
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.black, size: 17),
                      2.sbW,
                      Text(
                        '${widget.apartmentDetails?.apartment?.averageRating ?? '0.0'}',
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
                  widget.apartmentDetails?.apartment?.pricePerDay != null
                      ? MoneyServiceV2.formatNaira(
                          widget.apartmentDetails?.apartment?.pricePerDay
                                  ?.toDouble() ??
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
                '/night'.txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8D,
                ),
              ],
            ),
            24.sbH,
            PaymentInfoCard(booking: widget.apartmentDetails),
            30.sbH,
            'Scheduled Date'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            17.sbH,
            CustomCalendar(
              startDate: widget.apartmentDetails?.startDate,
              endDate: widget.apartmentDetails?.endDate,
            ),
            25.sbH,
            TimelineWidget(
              checkedInString:
                  widget.isCompleted == true ? 'Checked In' : 'Check In',
              checkedOutString:
                  widget.isCompleted == true ? 'Checked Out' : 'Check Out',
              checkedIn: widget.apartmentDetails?.apartment?.checkIn,
              checkedOut: widget.apartmentDetails?.apartment?.checkOut,
              isCompleted: widget.isCompleted ?? false,
            ),
            28.sbH,
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: AppColors.greyF7))),
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Apartment Details'.txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  12.sbH,
                  (widget.apartmentDetails?.apartment?.details ??
                          'No details available')
                      .txt(
                    size: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                  16.sbH,
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      if (widget.apartmentDetails?.apartment?.apartmentType
                              ?.isNotEmpty ==
                          true)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.bedroom,
                          info: widget
                                  .apartmentDetails?.apartment?.apartmentType ??
                              '',
                        ),
                      if (widget.apartmentDetails?.apartment
                                  ?.numberOfBedrooms !=
                              null &&
                          (widget.apartmentDetails?.apartment
                                      ?.numberOfBedrooms ??
                                  0) >
                              0)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.bathroom,
                          info:
                              '${widget.apartmentDetails?.apartment?.numberOfBedrooms} Bathroom${(widget.apartmentDetails?.apartment?.numberOfBedrooms ?? 0) > 1 ? 's' : ''}',
                        ),
                      if (widget.apartmentDetails?.apartment?.maxGuests !=
                              null &&
                          (widget.apartmentDetails?.apartment?.maxGuests ?? 0) >
                              0)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.guest,
                          info:
                              '${widget.apartmentDetails?.apartment?.maxGuests} Guest${(widget.apartmentDetails?.apartment?.maxGuests ?? 0) > 1 ? 's' : ''}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            16.sbH,
            AmenitiesWidget(
              amenityNames: widget.apartmentDetails?.apartment?.amenities ?? [],
              availableFeatures: allAmenities,
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            18.sbH,
            GuestInfoCard(user: widget.apartmentDetails!.user!),
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
                    child: (widget.apartmentDetails?.apartment?.address ?? '--')
                        .txt(
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
            widget.apartmentDetails?.apartment?.location?.coordinates != null
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
                              latLng: widget.apartmentDetails?.apartment
                                  ?.location?.latLng,
                              address:
                                  widget.apartmentDetails?.apartment?.address ??
                                      '',
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
            (widget.apartmentDetails?.apartment?.houseRules ??
                    'No rules available')
                .txt(
              size: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey8D,
            ),
            19.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            17.sbH,
            'Cancellation Policy'
                .txt14(fontWeight: FontWeight.w500, color: AppColors.black),
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
    );
  }

  _submit({required BookingStatus status}) async {
    if (widget.apartmentDetails?.id == null) return;

    final controller = ref.read(bookingController.notifier);

    final request = BookingStatusRequest(
      bookingId: widget.apartmentDetails!.id!,
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
