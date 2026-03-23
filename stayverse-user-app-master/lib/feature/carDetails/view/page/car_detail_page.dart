import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/download_image.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/carDetails/controller/car_details_controller.dart';
import 'package:stayverse/feature/carDetails/view/component/car_map_view.dart';
import 'package:stayverse/feature/carDetails/view/component/featured_image.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_agent_profile.dart';
import 'package:stayverse/feature/carDetails/view/component/ride_images.dart';
import 'package:stayverse/feature/carDetails/view/page/car_bookings_page.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class CarDetailPage extends ConsumerStatefulWidget {
  static const route = '/CarDetailPage';
  final Ride? ride;
  const CarDetailPage({super.key, this.ride});

  @override
  ConsumerState<CarDetailPage> createState() => _RideDetailPageState();
}

class _RideDetailPageState extends ConsumerState<CarDetailPage> {
  final PageController _pageController = PageController();

  late List<String> rideImages;
  late List<String> features;
  bool showAllFeatures = false;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(carDetailsController.notifier).getUnavailableBookingDays(
            widget.ride?.id ?? '',
          );
    });
    _populate();
    super.initState();
  }

  void _populate() {
    final ride = widget.ride;
    rideImages = ride?.rideImages?.isNotEmpty == true
        ? ride!.rideImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    features = ride?.features ?? [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleFeatures =
        showAllFeatures ? features : features.take(6).toList();

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          RideImages(
                            pageController: _pageController,
                            rideImages: rideImages,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: FavouriteBtn(
                              isFavourite:
                                  ref.watch(carDetailsController.select(
                                (state) =>
                                    state.isFavourite ??
                                    widget.ride?.isFavourite ??
                                    false,
                              )),
                              onTap: (action) {
                                ref
                                    .read(carDetailsController.notifier)
                                    .debounceFavourite(
                                      action: action,
                                      rideId: widget.ride?.id ?? '',
                                    );
                              },
                            ),
                          ),
                          DownloadImage(
                            getImageUrl: () async {
                              final index = _pageController.hasClients
                                  ? _pageController.page?.round() ?? 0
                                  : 0;
                              return rideImages[index];
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: rideImages.length,
                                effect: WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: context.color.primary,
                                  dotColor:
                                      Colors.white.withValues(alpha: 0.70),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.ride?.rideName ?? 'Unnamed Ride',
                          style: $styles.text.title1.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            $navigate.toWithParameters(ReviewsPage.route,
                                args: LeaveAReviewArgs(
                                  serviceType: ServiceType.rides.apiPoint,
                                  serviceId: widget.ride?.id ?? '',
                                ));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.black, size: 20),
                              Text(
                                (widget.ride?.averageRating ?? '0.0')
                                    .toString(),
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
                    Row(
                      children: [
                        Text(
                          widget.ride?.pricePerHour != null
                              ? MoneyServiceV2.formatNaira(
                                  widget.ride?.pricePerHour ?? 0,
                                  decimalDigits: 0)
                              : '₦--',
                          style: $styles.text.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                    const Gap(22),
                    const HorizontalLine(
                      color: Color(0xFFF7F7F7),
                    ),
                    const Gap(20),
                    Text(
                      'Ride Details',
                      style: $styles.text.title2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      widget.ride?.rideDescription ?? 'No details available',
                      style: $styles.text.body.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailItem(
                          icon: Icons.people,
                          text:
                              '${widget.ride?.maxPassengers ?? 'N/A'} Passengers',
                        ),
                        DetailItem(
                          icon: Icons.color_lens,
                          text: widget.ride?.color ?? 'N/A',
                        ),
                        DetailItem(
                          icon: Icons.directions_car,
                          text: widget.ride?.plateNumber ?? 'N/A',
                        ),
                      ],
                    ),
                    const Gap(20),
                    const HorizontalLine(
                      color: Color(0xFFF7F7F7),
                    ),
                    const Gap(20),
                    Text(
                      'Ride Features',
                      style: $styles.text.title2.copyWith(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(10),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: visibleFeatures.map((feature) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: FeatureItem(feature: feature),
                          );
                        }).toList(),
                      ),
                    ),
                    const Gap(10),
                    if (features.length > 6) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAllFeatures = !showAllFeatures;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              showAllFeatures
                                  ? 'Show less features'
                                  : 'Show all features',
                              style: $styles.text.body.copyWith(
                                color: Colors.black,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const Gap(20),
                    if (widget.ride?.agentId != null)
                      RideAgentProfile(agent: widget.ride!.agent!),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Ride Location",
                        style: $styles.text.body.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFFD1D1D6),
                          ),
                          const Gap(2),
                          Expanded(
                            child: Text(
                              widget.ride?.address ?? '--',
                              maxLines: 3,
                              style: $styles.text.body.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    widget.ride?.location?.coordinates != null
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
                                      latLng: widget.ride?.location?.latLng,
                                      address: widget.ride?.address ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Gap(20),
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
                      widget.ride?.rules ?? 'No rules available',
                      style: $styles.text.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'Cancellation Policy',
                      style: $styles.text.title2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'You may cancel your booking at any time. For a full refund, cancellations must be made at least 24 hours before the scheduled start time. Cancellations made within 24 hours are non-refundable. In case of emergencies, please contact our support team for assistance.',
                      style: $styles.text.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBtn.from(
                  text: 'Rent now',
                  expand: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    final ride = widget.ride;
    if (ride != null) {
      $navigate.toWithParameters(
        CarBookingsPage.route,
        args: ride,
      );
    }
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.black),
        const Gap(8),
        Text(
          text,
          style: $styles.text.body.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

                    // Column(
                    //   children: [
                    //     buildListItem(
                    //       'Security Official',
                    //       securityOfficialEnabled,
                    //     ),
                    //     buildListItem(
                    //       'Airport Pickup & Dropoff',
                    //       airportPickupEnabled,
                    //     ),
                    //   ],
                    // ),
                    // const Gap(20),