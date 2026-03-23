import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/service_location.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/ameneties.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_map_view.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_owner_profile.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/feature_items.dart';
import 'package:stayverse/feature/bookings/controller/bookings_controller.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/component/cancel_bookings_dialog.dart';
import 'package:stayverse/feature/bookings/view/page/leave_a_review_page.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/cancellation_policy.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';
import 'package:stayverse/shared/viewMutipleImage/model/view_mutiple_image_data.dart';
import 'package:stayverse/shared/viewMutipleImage/view/view_mutiple_image.dart';

class ApartmentBookedPage extends ConsumerStatefulWidget {
  static const route = '/ApartmentBookedPage';
  final Booking? data;
  const ApartmentBookedPage({super.key, this.data});

  @override
  ConsumerState<ApartmentBookedPage> createState() =>
      _ApartmentBookedPageState();
}

class _ApartmentBookedPageState extends ConsumerState<ApartmentBookedPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.data;
    final apartment = booking?.apartment;
    final isCompleted = booking?.status == BookingStatus.completed.name;

    final bookingStatus = BookingStatus.values.firstWhere(
      (e) => e.name == booking?.status,
      orElse: () => BookingStatus.pending,
    );

    return BrimSkeleton(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
              ApartmentImageCarousel(
                images: apartment?.apartmentImages ?? [],
                pageController: _pageController,
                status: booking?.status ?? 'Pending',
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ApartmentHeaderSection(
                      apartmentName:
                          apartment?.apartmentName ?? 'Unknown Apartment',
                      rating: apartment?.averageRating ?? 0.0,
                      apartmentBooking: booking!,
                    ),
                    const Gap(20),
                    BookingPriceCard(
                      startDate: booking.startDate,
                      endDate: booking.endDate,
                      totalPrice: booking.totalPrice,
                      status: booking.status,
                    ),
                    const Gap(20),
                    ApartmentDetailsSection(
                      description: apartment?.details ?? '',
                      numberOfBedrooms: apartment?.numberOfBedrooms ?? 0,
                      maxGuests: apartment?.maxGuests ?? 0,
                    ),
                    const Gap(20),
                    const HorizontalLine(),
                    const Gap(20),
                    ApartmentFeaturesSection(
                      amenities: apartment?.amenities ?? [],
                    ),
                    const Gap(20),
                    ApartmentOwnerProfile(
                      agent: booking.agent,
                    ),
                    LocationSection(
                      address: apartment?.address ?? '',
                      location: apartment?.location,
                    ),
                    const Gap(20),
                    RulesSection(
                      checkIn: apartment?.checkIn,
                      checkOut: apartment?.checkOut,
                      houseRules: apartment?.houseRules,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBtn.from(
                  text: isCompleted ? 'Leave a Review' : 'Cancel Booking',
                  expand: true,
                  bgColor: Colors.black,
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
                          serviceType: ServiceType.apartment.apiPoint,
                          serviceId: widget.data?.apartment?.id ?? '',
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            CancelBookingsDialog(onConfirm: () async {
                          final proceed = await ref
                              .read(bookingController.notifier)
                              .cancelBooking(
                                  booking.bookingId ?? '', bookingStatus);
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

class ApartmentImageCarousel extends StatelessWidget {
  final List<String> images;
  final PageController pageController;
  final String status;

  const ApartmentImageCarousel({
    super.key,
    required this.images,
    required this.pageController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.isNotEmpty ? images.length : 1,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: images.isNotEmpty
                      ? Image.network(
                          images[index],
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(AppAsset.apartment,
                                  height: 200, fit: BoxFit.cover),
                        ).onTap(() {
                          $navigate.toWithParameters(ViewMutipleImage.route,
                              args: ViewMutiplePageData(
                                images: images,
                                currentImageIndex: index,
                              ));
                        })
                      : Image.asset(AppAsset.apartment,
                          height: 200, fit: BoxFit.cover),
                );
              },
            ),
            BookingStatusBadge(status: status),
            if (images.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: images.length,
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
    );
  }
}

class BookingStatusBadge extends StatelessWidget {
  final String status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: context.color.primary,
        ),
        child: Center(
          child: Text(
            status.capitalize(),
            style: $styles.text.title1.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ApartmentHeaderSection extends StatelessWidget {
  final String apartmentName;
  final double rating;
  final Booking apartmentBooking;

  const ApartmentHeaderSection({
    super.key,
    required this.apartmentName,
    required this.rating,
    required this.apartmentBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            apartmentName,
            style: $styles.text.title1.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            $navigate.toWithParameters(ReviewsPage.route,
                args: LeaveAReviewArgs(
                  serviceType: ServiceType.apartment.apiPoint,
                  serviceId: apartmentBooking.apartment?.id ?? '',
                ));
          },
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.black, size: 20),
              Text(
                rating.toStringAsFixed(1),
                style: $styles.text.bodyBold.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingPriceCard extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final double? totalPrice;
  final String? status;

  const BookingPriceCard({
    super.key,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateTimeService.daysBetween(startDate!, endDate!)} Days (${DateTimeService.format(startDate, format: 'MMM dd, yyyy')} - ${DateTimeService.format(endDate, format: 'MMM dd, yyyy')})',
            style: $styles.text.body.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MoneyServiceV2.formatNaira(totalPrice, decimalDigits: 0),
                style: $styles.text.body.copyWith(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Paid',
                style: $styles.text.body.copyWith(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w400,
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApartmentDetailsSection extends StatelessWidget {
  final String description;
  final int numberOfBedrooms;
  final int maxGuests;

  const ApartmentDetailsSection({
    super.key,
    required this.description,
    required this.numberOfBedrooms,
    required this.maxGuests,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          description.isNotEmpty ? description : "No description available",
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
            DetailItem(icon: AppAsset.bed, text: '$numberOfBedrooms Bedrooms'),
            DetailItem(
                icon: AppAsset.solarBath,
                text: '2 Bathrooms'), // Hardcoded as not in model
            DetailItem(icon: AppAsset.fluentPeople, text: '$maxGuests Guests'),
          ],
        ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  final String icon;
  final String text;

  const DetailItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const Gap(2),
          Text(
            text,
            style: $styles.text.body.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }
}

class ApartmentFeaturesSection extends StatefulWidget {
  final List<String> amenities;

  const ApartmentFeaturesSection({super.key, required this.amenities});

  @override
  State<ApartmentFeaturesSection> createState() =>
      _ApartmentFeaturesSectionState();
}

class _ApartmentFeaturesSectionState extends State<ApartmentFeaturesSection>
    with SingleTickerProviderStateMixin {
  bool showAllAmenities = false;

  @override
  Widget build(BuildContext context) {
    final amenities = widget.amenities;
    final visibleAmenities =
        showAllAmenities ? amenities : amenities.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Column(
            children: visibleAmenities.map((amenity) {
              final icon = amenityIconMap[amenity] ?? AppAsset.solarGallery;
              return FeatureItem(imageAsset: icon, text: amenity);
            }).toList(),
          ),
        ),
        if (amenities.length > 6) ...[
          const Gap(10),
          GestureDetector(
            onTap: () {
              setState(() => showAllAmenities = !showAllAmenities);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 45,
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
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ShowAllAmenitiesButton extends StatelessWidget {
  const ShowAllAmenitiesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Show all amenities',
          style: $styles.text.body.copyWith(
            color: Colors.black,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ApartmentHostSection extends StatelessWidget {
  final Apartment? data;

  const ApartmentHostSection({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final hostName = data?.agent != null
        ? '${data?.agent!.user?.firstname ?? ''} ${data?.agent!.user?.lastname ?? ''}'
            .trim()
        : 'Unknown Host';

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(AppAsset.profilePic),
        ),
        title: Text(
          hostName,
          style: $styles.text.body.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 10.5,
          ),
        ),
        subtitle: Text(
          'Apartment Host',
          style: $styles.text.body.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 9.5,
            color: Colors.grey[600],
          ),
        ),
        trailing: CircleAvatar(
          backgroundColor: context.color.primary,
          child: SvgPicture.asset(AppAsset.chatIcon),
        ),
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  final String address;
  final ServiceLocation? location;

  const LocationSection({super.key, required this.address, this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Where you\'ll be',
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
              Expanded(
                child: Text(
                  address.isNotEmpty ? address : 'Address not available',
                  style: $styles.text.body.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: const Color(0xFF898A8D),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(20),
        if (location?.latLng != null)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ApartmentMapView(
                latLng: location!.latLng,
                address: address,
              ),
            ),
          ),
      ],
    );
  }
}

class RulesSection extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? houseRules;

  const RulesSection({
    super.key,
    this.checkIn,
    this.checkOut,
    this.houseRules,
  });

  String get checkInTime {
    if (checkIn != null) {
      return '${checkIn!.hour.toString().padLeft(2, '0')}:${checkIn!.minute.toString().padLeft(2, '0')}';
    }
    return '11:00AM';
  }

  String get checkOutTime {
    if (checkOut != null) {
      return '${checkOut!.hour.toString().padLeft(2, '0')}:${checkOut!.minute.toString().padLeft(2, '0')}';
    }
    return '12:00PM';
  }

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
          'Check-in: $checkInTime - 7:00PM \nCheckout before $checkOutTime',
          style: $styles.text.body.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const Gap(20),
        const CancellationPolicySection()
      ],
    );
  }
}
