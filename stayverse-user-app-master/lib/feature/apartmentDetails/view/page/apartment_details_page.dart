import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/util/location/location_privacy.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/controller/aparment_details_controller.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/ameneties.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/details_item.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/feature_items.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/download_image.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_owner_profile.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_images.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_bookings_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class ApartmentDetailsPage extends ConsumerStatefulWidget {
  static const route = '/ApartmentDetailsPage';
  final Apartment? apartment;
  const ApartmentDetailsPage({super.key, required this.apartment});

  @override
  ConsumerState<ApartmentDetailsPage> createState() =>
      _ApartmentDetailsPageState();
}

class _ApartmentDetailsPageState extends ConsumerState<ApartmentDetailsPage> {
  final PageController _pageController = PageController();

  late List<String> apartmentImages;

  late List<String> amenities;
  bool showAllAmenities = false;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(apartmentDetailsController.notifier).getUnavailableBookingDays(
            widget.apartment?.id ?? '',
          );
    });
    _populate();
    super.initState();
  }

  void _populate() {
    final apartment = widget.apartment;
    apartmentImages = apartment?.apartmentImages?.isNotEmpty == true
        ? apartment!.apartmentImages!
        : List.generate(
            3,
            (index) => Constant.defaultApartmentImage,
          );
    amenities = apartment?.amenities ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final visibleAmenities =
        showAllAmenities ? amenities : amenities.take(6).toList();

    return BrimSkeleton(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
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
                          ApartmentImages(
                              pageController: _pageController,
                              apartmentImages: apartmentImages),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: FavouriteBtn(
                              isFavourite:
                                  ref.watch(apartmentDetailsController.select(
                                (state) =>
                                    state.isFavourite ??
                                    widget.apartment?.isFavourite ??
                                    false,
                              )),
                              onTap: (action) {
                                ref
                                    .read(apartmentDetailsController.notifier)
                                    .debounceFavourite(
                                      action: action,
                                      apartmentId: widget.apartment?.id ?? '',
                                    );
                              },
                            ),
                          ),
                          DownloadImage(
                            getImageUrl: () async {
                              final index = _pageController.hasClients
                                  ? _pageController.page?.round() ?? 0
                                  : 0;
                              return apartmentImages[index];
                            },
                          ),
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
                        Expanded(
                          child: Text(
                            widget.apartment?.apartmentName ??
                                'Unnamed Apartment',
                            overflow: TextOverflow.ellipsis,
                            style: $styles.text.title1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Gap(40),
                        GestureDetector(
                          onTap: () {
                            $navigate.toWithParameters(ReviewsPage.route,
                                args: LeaveAReviewArgs(
                                  serviceType: ServiceType.apartment.apiPoint,
                                  serviceId: widget.apartment?.id ?? '',
                                ));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.black, size: 20),
                              Text(
                                (widget.apartment?.averageRating ?? '0.0')
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
                          widget.apartment?.pricePerDay != null
                              ? MoneyServiceV2.formatNaira(
                                  widget.apartment?.pricePerDay ?? 0,
                                  decimalDigits: 0)
                              : '₦--',
                          style: $styles.text.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '/night',
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
                      'Apartment Details',
                      style: $styles.text.title2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      widget.apartment?.details ?? 'No details available',
                      style: $styles.text.body.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailItem(
                          imageAsset: AppAsset.bed,
                          text:
                              '${widget.apartment?.numberOfBedrooms ?? 'N/A'} Bedrooms',
                        ),
                        DetailItem(
                          imageAsset: AppAsset.solarBath,
                          text: '2 Bathrooms',
                        ),
                        DetailItem(
                          imageAsset: AppAsset.fluentPeople,
                          text:
                              '${widget.apartment?.maxGuests ?? 'N/A'} Guests',
                        ),
                      ],
                    ),
                    const Gap(20),
                    const HorizontalLine(
                      color: Color(0xFFF7F7F7),
                    ),
                    const Gap(20),
                    Text(
                      'Apartment Features',
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
                        children: visibleAmenities.map((amenity) {
                          return FeatureItem(
                            imageAsset: amenityIconMap[amenity] ??
                                AppAsset.solarGallery,
                            text: amenity,
                          );
                        }).toList(),
                      ),
                    ),
                    const Gap(20),
                    if (amenities.length > 6) ...[
                      const Gap(10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAllAmenities = !showAllAmenities;
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
                              showAllAmenities
                                  ? 'Show less amenities'
                                  : 'Show all amenities',
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
                    ApartmentOwnerProfile(
                      agent: widget.apartment?.agent,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Where you'll be",
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
                              LocationPrivacy.extractArea(
                                  widget.apartment?.address),
                              maxLines: 3,
                              style: $styles.text.body.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey.shade500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Exact address and map are shared after payment is completed.',
                        style: $styles.text.body.copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                      widget.apartment?.houseRules ?? 'No rules available',
                      style: $styles.text.body.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    if (widget.apartment?.checkIn != null ||
                        widget.apartment?.checkOut != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Check-in: ${widget.apartment?.checkIn != null ? DateTimeService.formatTo12HourTime(widget.apartment!.checkIn!) : 'Not specified'}\n'
                          'Check-out: ${widget.apartment?.checkOut != null ? DateTimeService.formatTo12HourTime(widget.apartment!.checkOut!) : 'Not specified'}',
                          style: $styles.text.body.copyWith(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
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
                      "You may cancel your booking at any time. For a full refund, cancellations must be made at least 24 hours before the scheduled start time. Cancellations made within 24 hours are non-refundable. In case of emergencies, please contact our support team for assistance.",
                      style: $styles.text.body.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
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
    final apartment = widget.apartment;
    if (apartment != null) {
      $navigate.toWithParameters(ApartmentBookingsPage.route, args: apartment);
    }
  }
}
