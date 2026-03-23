import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/media_type_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_advert_controller.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_amenity_post_controller.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/create_ride_request.dart';
import 'package:stayvers_agent/feature/dashboard/view/page/dashboard_page.dart';
import 'package:stayvers_agent/feature/discover/model/data/confirmation_page_args.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../discover/view/component/confirmation_page.dart';
import '../../controller/create_ride_controller.dart';
import '../component/ride_amenities_widget.dart';
import '../ui_state/ride_advert_state.dart';

class CarDetailsPostPage extends ConsumerStatefulWidget {
  static const route = '/CarDetailsPostPage';
  const CarDetailsPostPage({super.key});

  @override
  ConsumerState<CarDetailsPostPage> createState() => _CarDetailsPostPageState();
}

class _CarDetailsPostPageState extends ConsumerState<CarDetailsPostPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Ensure we're using the latest data from the controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createRideAdvertProvider.notifier).updateStateFromControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(rideAmenityProvider);
    final formData = ref.watch(createRideAdvertProvider);
    final formattedPrice = formData.pricePerHour! > 0
        ? 'N${formData.pricePerHour!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}k'
        : 'N/A';
    return BrimSkeleton(
      isBusy: ref.watch(rideController).isBusy,
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
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: formData.rideImages?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: formData.rideImages != null &&
                                File(formData.rideImages![index].path)
                                    .existsSync()
                            ? Image.file(
                                File(formData.rideImages![index].path),
                                fit: BoxFit.cover,
                                width: 160,
                              )
                            : const Center(
                                child: Text(
                                  'Image not found',
                                  style: TextStyle(
                                      color: AppColors.black0C, fontSize: 12),
                                ),
                              ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 13,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: formData.rideImages?.length ?? 0,
                      effect: WormEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: AppColors.white,
                        dotColor: AppColors.white.withValues(alpha: 0.70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.sbH,
            (formData.rideName?.isNotEmpty == true ? formData.rideName : 'N/A')!
                .txt20(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            //     Row(
            //       children: [
            //         const Icon(
            //           Icons.star,
            //           color: AppColors.black,
            //           size: 17,
            //         ),
            //         '4.68'.txt16(
            //           fontWeight: FontWeight.w500,
            //           color: AppColors.black,
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            8.sbH,
            Row(
              children: [
                formattedPrice.txt16(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                '/24hrs'.txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8D,
                ),
              ],
            ),
            22.sbH,
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: AppColors.greyF7))),
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Ride Details'.txt16(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  12.sbH,
                  (formData.rideDescription?.isNotEmpty == true
                          ? formData.rideDescription
                          : 'N/A')!
                      .txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                ],
              ),
            ),
            16.sbH,
            RideAmenitiesWidget(
              selectedFeatureNames: formData.features ?? [],
              allAvailableAmenities: allAmenities,
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            16.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            'Rules'.txt16(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            (formData.rules?.isNotEmpty == true ? formData.rules : 'N/A')!
                .txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.grey8D,
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            16.sbH,
            'Cancellation Policy'.txt16(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            'You may cancel your booking at any time. For a full refund, cancellations must be made at least 24 hours before the scheduled start time. Cancellations made within 24 hours are non-refundable. In case of emergencies, please contact our support team for assistance.'
                .txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.grey8D,
            ),
            53.sbH,
            AppBtn.from(
              text: 'Post',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              bgColor: AppColors.black,
              onPressed: () {
                _submit(context, ref);
              },
            ),
            17.sbH,
          ],
        ),
      ),
    );
  }
}

void _submit(BuildContext context, WidgetRef ref) async {
  // Create the request object from the form data
  final formData = ref.read(createRideAdvertProvider);
  final controller = ref.read(rideController.notifier);

  Future<CreateRideRequest> processImagesForUpload(
      RideAdvertState formData) async {
    // Create the base request
    final request = formData.toCreateRideRequest();

    List<MultipartFile> processedImages = [];

    for (var image in formData.rideImages ?? []) {
      if (File(image.path).existsSync()) {
        final extension = image.name.split('.').last.toLowerCase();

        // Determine content type based on file extension
        final contentType = getContentTypeFromExtension(extension);
        processedImages.add(await MultipartFile.fromFile(image.path,
            filename: image.name, contentType: contentType));
      }
    }

    // Return updated request with processed images
    return request.copyWith(rideImages: processedImages);
  }

  final processedRequest = await processImagesForUpload(formData);

  // Submit to backend
  final proceed = await controller.createRide(processedRequest);
  if (proceed) {
    ref.read(createRideAdvertProvider.notifier).resetAllFormData(ref);
    $navigate.toWithParameters(
      ConfirmationPage.route,
      args: ConfirmationPageArgs(
        message:
            'Your Post is under review, we’ll let you know when it goes live',
        onContinue: () {
          $navigate.clearAllTo(DashBoardPage.route);
        },
      ),
    );
  }
}
