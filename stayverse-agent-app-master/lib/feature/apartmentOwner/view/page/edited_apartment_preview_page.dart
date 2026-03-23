import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/media_type_extension.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/edit_apartment_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/preview_amenities_controller.dart';
import 'package:stayvers_agent/feature/dashboard/view/page/dashboard_page.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../controller/apartment_advert_notifier.dart';
import '../../model/data/create_apartment_request.dart';
import '../component/apartment_info_container.dart';
import '../component/preview_amenity_widget.dart';
import '../ui_state/apartment_advert_state.dart';

class EditedApartmentPreviewPage extends ConsumerStatefulWidget {
  static const route = '/EditedApartmentPreviewPage';
  final String? apartmentId;
  const EditedApartmentPreviewPage({super.key, this.apartmentId});

  @override
  ConsumerState<EditedApartmentPreviewPage> createState() =>
      _EditedApartmentPreviewPageState();
}

class _EditedApartmentPreviewPageState
    extends ConsumerState<EditedApartmentPreviewPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Ensure we're using the latest data from the controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editApartmentAdvert.notifier).updateStateFromControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = ref.watch(amenityProvider);
    final formData = ref.watch(editApartmentAdvert);
    final formattedPrice = formData.pricePerDay != null &&
            formData.pricePerDay! > 0
        ? 'N${formData.pricePerDay!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}k'
        : 'N/A';

    return BrimSkeleton(
      isBusy: ref.watch(editApartmentController).isBusy,
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: 'Preview'.txt20(
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
                    itemCount: formData.apartmentImages?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: formData.apartmentImages != null
                            ? (formData.apartmentImages![index].isRemote
                                ? Image.network(
                                    formData.apartmentImages![index].path,
                                    fit: BoxFit.cover,
                                    width: 160,
                                    errorBuilder: (_, __, ___) => const Center(
                                        child: Text('Image failed to load')),
                                  )
                                : Image.file(
                                    File(formData.apartmentImages![index].path),
                                    fit: BoxFit.cover,
                                    width: 160,
                                  ))
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
                      count: formData.apartmentImages?.length ?? 0,
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
            (formData.apartmentName?.isNotEmpty == true
                    ? formData.apartmentName
                    : 'N/A')!
                .txt20(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            8.sbH,
            Row(
              children: [
                formattedPrice.txt16(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                '/night'.txt14(
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
                  'Apartment Details'.txt16(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  12.sbH,
                  (formData.details?.isNotEmpty == true
                          ? formData.details
                          : 'N/A')!
                      .txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey8D,
                  ),
                  14.sbH,
                  Wrap(
                    spacing: 16.0, // Add space between items
                    runSpacing: 16.0, // Add space between lines
                    children: [
                      if (formData.apartmentType?.isNotEmpty == true)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.bedroom,
                          info: formData.apartmentType ?? '',
                        ),
                      if (formData.numberOfBathrooms != null &&
                          formData.numberOfBathrooms! > 0)
                        ApartmentDetailInfoContainer(
                            infoIcon: AppIcons.bathroom,
                            info:
                                '${formData.numberOfBathrooms} Bathroom${formData.numberOfBathrooms! > 1 ? 's' : ''}'),
                      if (formData.maxGuests != null && formData.maxGuests! > 0)
                        ApartmentDetailInfoContainer(
                          infoIcon: AppIcons.guest,
                          info:
                              '${formData.maxGuests} Guest${formData.maxGuests! > 1 ? 's' : ''}',
                        ),
                    ],
                  )
                ],
              ),
            ),
            16.sbH,
            AmenitiesWidget(
              amenityNames: formData.amenities ?? [],
              availableFeatures: allAmenities,
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: 'Location'.txt16(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.grey8D,
                    size: 18,
                  ),
                  Expanded(
                    child: (formData.location?.isNotEmpty == true
                            ? formData.location
                            : 'N/A')!
                        .txt14(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyD6,
                    ),
                  ),
                ],
              ),
            ),
            23.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            'House Rules'.txt16(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            10.sbH,
            (formData.houseRules?.isNotEmpty == true
                    ? formData.houseRules
                    : 'N/A')!
                .txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.greyD6,
            ),
            23.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            'Time'.txt16(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            10.sbH,
            (formData.checkIn?.isNotEmpty == true
                    ? 'Check-in: ${DateTimeService.formatTime(formData.checkIn)}'
                    : 'N/A')
                .txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.greyD6,
            ),
            (formData.checkOut?.isNotEmpty == true
                    ? 'Check-out: ${DateTimeService.formatTime(formData.checkOut)}'
                    : 'N/A')
                .txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.greyD6,
            ),
            53.sbH,
            AppBtn.from(
              text: 'Save Changes',
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

  void _submit(BuildContext context, WidgetRef ref) async {
    // Create the request object from the form data
    final formData = ref.read(editApartmentAdvert);
    final controller = ref.read(editApartmentController.notifier);

    Future<CreateApartmentRequest> processImagesForUpload(
        ApartmentAdvertState formData) async {
      // Create the base request
      final request = formData.toCreateApartmentRequest();

      // Process images
      List<MultipartFile> processedImages = [];

      // final images = formData.apartmentImages ?? [];
      // print("Number of images selected: ${images.length}");

      for (var image in formData.apartmentImages ?? []) {
        // print("Image selected -> name: ${image.name}, path: ${image.path}");
        if (File(image.path).existsSync()) {
          final extension = image.name.split('.').last.toLowerCase();

          // Determine content type based on file extension
          final contentType = getContentTypeFromExtension(extension);

          processedImages.add(await MultipartFile.fromFile(image.path,
              filename: image.name, contentType: contentType));
        }
      }

      // print("✅ Processed ${processedImages.length} images for upload.");

      // Return updated request with processed images
      return request.copyWith(apartmentImages: processedImages);
    }

    final processedRequest = await processImagesForUpload(formData);

    // Submit to backend
    final proceed = await controller.editApartment(
        widget.apartmentId ?? '', processedRequest);
    if (proceed) {
      ref.read(editApartmentAdvert.notifier).resetAllFormData(ref);
      $navigate.clearAllTo(DashBoardPage.route);
    }
  }
}
