import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/image_picker_controller.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/dash_boder.dart';

import '../../../../../core/config/constant.dart';

class CoverPhotoWidget extends ConsumerWidget {
  final ProviderMode mode;
  const CoverPhotoWidget({
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

    final coverImage = imageState["cover"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Cover Photo',
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
                dashColor: AppColors.greyD6),
            child: Container(
              width: 325,
              height: 189,
              decoration: BoxDecoration(
                color: AppColors.greyE7,
                borderRadius: BorderRadius.circular(5),
                image: coverImage != null
                    ? DecorationImage(
                        image: coverImage.isRemote
                            ? NetworkImage(coverImage.path) as ImageProvider
                            : FileImage(File(coverImage.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: coverImage == null
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
                          onPressed: () => notifier.pickCoverPhoto(),
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
                          notifier.removeImage("cover");
                        },
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
