import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/dash_boder.dart';

import '../../../../../shared/app_icons.dart';
import '../../../../../shared/buttons.dart';
import '../../../apartmentOwner/controller/image_picker_controller.dart';

class ProfilePictureWidget extends ConsumerWidget {
  final ProviderMode mode;
  const ProfilePictureWidget({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickImageProvider = mode == ProviderMode.edit
    ? editPickImageProvider
    : createPickImageProvider;
    final imageState = ref.watch(pickImageProvider);
    final notifier = ref.read(pickImageProvider.notifier);

    final profileImage = imageState["profile"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Profile Picture',
            textAlign: TextAlign.start,
            style: $styles.text.h4.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
        Gap(10.spaceScale),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: CustomPaint(
            painter: DottedPainter(
                recRadius: 5,
                shape: DottedShape.rectangle,
                dashColor: AppColors.grey97),
            child: Container(
              width: 218,
              height: 189,
              decoration: BoxDecoration(
                color: AppColors.greyE7,
                borderRadius: BorderRadius.circular(5),
                image: profileImage != null
                    ? DecorationImage(
                        image: profileImage.isRemote
                            ? NetworkImage(profileImage.path) as ImageProvider
                            : FileImage(File(profileImage.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: profileImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        20.sbH,
                        const Expanded(
                          child: AppIcon(
                            AppIcons.img_upload,
                            size: 41,
                            color: AppColors.greyD9,
                          ),
                        ),
                        AppBtn(
                          onPressed: () => notifier.pickProfilePicture(),
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
                    )
                  : Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          notifier.removeImage("profile");
                        },
                      ),
                    ),
            ),
          ),
        ),
        4.sbH,
        'Photo must be portrait and shows the face clearly (Max 5MB)'.txt10(
          fontWeight: FontWeight.w500,
          color: AppColors.grey8D,
        ),
      ],
    );
  }
}
