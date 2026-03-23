import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/controller/review_controller.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_response.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_amenity_post_controller.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/car_map_view.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/delete_ride_dialog.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_amenities_widget.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_images.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edit_ride_advert_page.dart';
import 'package:stayvers_agent/feature/profile/controller/listed_ride_controller.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ListedRideDetailsPage extends ConsumerStatefulWidget {
  static const route = '/ListedRideDetailsPage';
  const ListedRideDetailsPage({super.key, this.rideDetails});
  final Ride? rideDetails;

  @override
  ConsumerState<ListedRideDetailsPage> createState() =>
      _ListedRideDetailsPageState();
}

class _ListedRideDetailsPageState extends ConsumerState<ListedRideDetailsPage> {
  final PageController _pageController = PageController();
  late List<String> rideImages;

  late List<String> rideAmenities;

  @override
  void initState() {
    _populate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewController.notifier).getReviews(
            ServiceType.carOwner.id,
            widget.rideDetails?.id ?? '',
            limit: 1,
          );
    });
    super.initState();
  }

  void _populate() {
    final rideDetails = widget.rideDetails;
    rideImages = rideDetails?.rideImages?.isNotEmpty == true
        ? rideDetails!.rideImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    rideAmenities = rideDetails?.features ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(rideAmenityProvider);
    return BrimSkeleton(
      isBusy: ref.watch(listedRideController).isLoading,
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
                (widget.rideDetails?.rideName ?? 'Unnamed Ride').txt20(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.black, size: 17),
                    2.sbW,
                    Text(
                      '${widget.rideDetails?.averageRating ?? '0.0'}',
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
                (widget.rideDetails?.pricePerHour != null
                        ? MoneyServiceV2.formatNaira(
                            widget.rideDetails?.pricePerHour?.toDouble() ?? 0,
                            decimalDigits: 0)
                        : '₦--')
                    .txt16(
                  fontFamily: Constant.inter,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                '/hr'.txt14(
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
                    serviceType: ServiceType.carOwner.id,
                    serviceId: widget.rideDetails?.id ?? '',
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
                  'Ride Details'.txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  12.sbH,
                  (widget.rideDetails?.rideDescription ??
                          'No details available')
                      .txt(
                    size: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                ],
              ),
            ),
            16.sbH,
            RideAmenitiesWidget(
              selectedFeatureNames: rideAmenities,
              allAvailableAmenities: allAmenities,
            ),
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
                    child: (widget.rideDetails?.address ?? '--').txt(
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
            widget.rideDetails?.location?.coordinates != null
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
                              latLng: widget.rideDetails?.location?.latLng,
                              address: widget.rideDetails?.address ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            23.sbH,
            'Rules'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            10.sbH,
            (widget.rideDetails?.rules ?? 'No rules available').txt(
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
              text: 'Delete Listing',
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
                  builder: (_) => const DeleteRideDialog(),
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
      EditRideAdvertPage.route,
      args: widget.rideDetails ?? {},
    );
  }
}

class LatestReviewCard extends StatelessWidget {
  const LatestReviewCard({
    super.key,
    required this.latest,
  });

  final Review? latest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: isEmpty(latest?.user?.profilePicture)
                        ? Text(
                            latest?.user?.firstname?.isNotEmpty == true
                                ? latest!.user!.firstname![0].toUpperCase()
                                : 'U',
                            style: $styles.text.title1.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              latest?.user?.profilePicture ?? '',
                            )),
                  ),
                ),
                const Gap(14),
                (latest?.user?.fullName ?? "Unknown").txt14(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ],
            ),
            RatingBarIndicator(
              rating: latest?.rating ?? 0,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 14,
              unratedColor: Colors.grey,
            )
          ],
        ),
        6.sbH,
        Text(
          latest?.review ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: $styles.text.body.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.grey8D,
          ),
        )
      ],
    );
  }
}
