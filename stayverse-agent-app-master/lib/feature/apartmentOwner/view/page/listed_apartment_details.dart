import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/controller/review_controller.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/preview_amenities_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/apartment_image.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/delete_apartment_dialog.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/preview_amenity_widget.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/edit_apartment_advert_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/car_map_view.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/listed_ride_details_page.dart';
import 'package:stayvers_agent/feature/profile/controller/listed_apartment_controller.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../component/apartment_info_container.dart';

class ListedApartmentDetailsPage extends ConsumerStatefulWidget {
  static const route = '/ListedApartmentDetailsPage';
  const ListedApartmentDetailsPage({super.key, this.apartmentDetails});
  final Apartment? apartmentDetails;

  @override
  ConsumerState<ListedApartmentDetailsPage> createState() =>
      _ListedApartmentDetailsPageState();
}

class _ListedApartmentDetailsPageState
    extends ConsumerState<ListedApartmentDetailsPage> {
  final PageController _pageController = PageController();
  late List<String> apartmentImages;

  late List<String> apartmentAmenities;

  @override
  void initState() {
    _populate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewController.notifier).getReviews(
            ServiceType.apartmentOwner.id,
            widget.apartmentDetails?.id ?? '',
            limit: 1,
          );
    });
    super.initState();
  }

  void _populate() {
    final apartmentDetails = widget.apartmentDetails;
    apartmentImages = apartmentDetails?.apartmentImages?.isNotEmpty == true
        ? apartmentDetails!.apartmentImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    apartmentAmenities = apartmentDetails?.amenities ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(amenityProvider);
    return BrimSkeleton(
      isBusy: ref.watch(listedApartmentController).isLoading,
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
                (widget.apartmentDetails?.apartmentName ?? 'Unnamed Apartment')
                    .txt20(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.black, size: 17),
                    2.sbW,
                    Text(
                      '${widget.apartmentDetails?.averageRating ?? '0.0'}',
                      style: $styles.text.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        letterSpacing: 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                (widget.apartmentDetails?.pricePerDay != null
                        ? MoneyServiceV2.formatNaira(
                            widget.apartmentDetails?.pricePerDay?.toDouble() ??
                                0,
                            decimalDigits: 0)
                        : '₦--')
                    .txt16(
                  fontFamily: Constant.inter,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                '/night'.txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8D,
                ),
              ],
            ),
            24.sbH,
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
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 21),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.02),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    final state = ref.watch(reviewController);
                    final latest =
                        state.reviews.isNotEmpty ? state.reviews.first : null;

                    if (state.isLoading) {
                      return "Loading review...".txt14(
                          fontWeight: FontWeight.w500, color: AppColors.black);
                    }

                    if (latest == null) {
                      return "No reviews yet".txt14(
                          fontWeight: FontWeight.w500, color: AppColors.black);
                    }

                    return LatestReviewCard(latest: latest);
                  },
                ),
              ),
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
                  'Apartment Details'.txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  12.sbH,
                  (widget.apartmentDetails?.details ?? 'No details available')
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
                      if (widget.apartmentDetails?.apartmentType?.isNotEmpty ==
                          true)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.bedroom,
                          info: widget.apartmentDetails?.apartmentType ?? '',
                        ),
                      if (widget.apartmentDetails?.numberOfBedrooms != null &&
                          (widget.apartmentDetails?.numberOfBedrooms ?? 0) > 0)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.bathroom,
                          info:
                              '${widget.apartmentDetails?.numberOfBedrooms} Bathroom${(widget.apartmentDetails?.numberOfBedrooms ?? 0) > 1 ? 's' : ''}',
                        ),
                      if (widget.apartmentDetails?.maxGuests != null &&
                          (widget.apartmentDetails?.maxGuests ?? 0) > 0)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.guest,
                          info:
                              '${widget.apartmentDetails?.maxGuests} Guest${(widget.apartmentDetails?.maxGuests ?? 0) > 1 ? 's' : ''}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            16.sbH,
            AmenitiesWidget(
              amenityNames: widget.apartmentDetails?.amenities ?? [],
              availableFeatures: allAmenities,
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            18.sbH,
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
                    child: (widget.apartmentDetails?.address ?? '--').txt(
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
            widget.apartmentDetails?.location?.coordinates != null
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
                              latLng: widget.apartmentDetails?.location?.latLng,
                              address: widget.apartmentDetails?.address ?? '',
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
            (widget.apartmentDetails?.houseRules ?? 'No rules available').txt(
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
            53.sbH,
            AppBtn.from(
              text: 'Edit',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              bgColor: AppColors.primaryyellow,
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () {
                _editPost();
              },
            ),
            10.sbH,
            AppBtn.from(
              text: 'Delete Apartment',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              bgColor: AppColors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DeleteApartmentDialog(),
                );
              },
            ),
            21.sbH,
          ],
        ),
      ),
    );
  }

  void _editPost() {
    $navigate.toWithParameters(
      EditApartmentAdvertPage.route,
      args: widget.apartmentDetails ?? {},
    );
  }
}
