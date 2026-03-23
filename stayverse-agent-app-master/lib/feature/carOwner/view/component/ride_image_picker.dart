import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/image_picker_ui_state.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_image_picker_controller.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

import '../../controller/ride_advert_controller.dart';

class RideImagePickerWidget extends ConsumerWidget {
  final ProviderMode mode;
  const RideImagePickerWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider = mode == ProviderMode.create
        ? createRideImagePickerProvider
        : editRideImagePickerProvider;
    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;

    final images = ref.watch(imageProvider);
    final notifier = ref.read(imageProvider.notifier);
    final rideState = ref.read(advertProvider);
    final isValid = images.length >= 2 && images.length <= 12;
    final isAtMaximum = images.length >= 12;

    if (rideState.rideImages?.isNotEmpty == true && images.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(imageProvider.notifier).setRideImages(
              rideState.rideImages?.cast<ImageFile>() ?? [],
            );
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Upload Ride Images',
            textAlign: TextAlign.start,
            style: $styles.text.h4.copyWith(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
        Gap(10.spaceScale),
        if (images.isEmpty)
          Container(
            width: 218,
            height: 189,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.blue50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.sbH,
                const Expanded(
                  child: AppIcon(
                    AppIcons.img_upload,
                    size: 41,
                  ),
                ),
                AppBtn(
                  onPressed: () => notifier.pickImages(),
                  semanticLabel: '',
                  borderRadius: 5,
                  expand: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: 'Click to upload image'.txt(
                    size: 9,
                    fontWeight: FontWeight.w400,
                    fontFamily: Constant.satoshi,
                    color: AppColors.black,
                  ),
                ).paddingSymmetric(horizontal: 10),
                10.sbH,
              ],
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isAtMaximum ? images.length : images.length + 1,
              itemBuilder: (context, index) {
                if (index == images.length && !isAtMaximum) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.blue50),
                      ),
                      child: InkWell(
                        onTap: () => notifier.pickImages(),
                        child: const Center(
                          child: AppIcon(
                            AppIcons.img_upload,
                            size: 41,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppBtn(
                        onPressed: () => notifier.removeImage(index),
                        semanticLabel: '',
                        bgColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        child: const AppIcon(
                          AppIcons.cancel,
                          size: 26,
                          color: AppColors.grey8D,
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: images[index].isRemote
                              ? Image.network(
                                  images[index].path,
                                  fit: BoxFit.cover,
                                  width: 160,
                                )
                              : Image.file(
                                  File(images[index].path),
                                  fit: BoxFit.cover,
                                  width: 160,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        4.sbH,
        'Supported formats are .jpg, .gif and .png (Max 5MB)'.txt10(
          fontWeight: FontWeight.w500,
          color: AppColors.grey8D,
        ),
        if (!isValid)
          '**minimum of 2 images required**'.txt10(
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
      ],
    );
  }
}
