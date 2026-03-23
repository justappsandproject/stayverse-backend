

import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/buttons.dart';

class HeaderComponent extends StatelessWidget {
  final bool useHeader, showBackIcon;
  final String? headerTxt;
  const HeaderComponent({
    super.key,
    this.useHeader = true,
    required this.showBackIcon,
    this.headerTxt,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Yellow curved background
        SvgPicture.asset(AppAsset.vectorShape),
        // Emoji

        useHeader
            ? Positioned(
                top: 20,
                child: SafeArea(
                  child: Text(headerTxt ?? 'Withdraw Successful',
                    style: $styles.text.title1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: $styles.colors.black,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        showBackIcon == false
            ? const SizedBox.shrink()
            : Positioned(
                top: 25,
                left: 18,
                child: SafeArea(
                  child: AppBtn.basic(
                    semanticLabel: 'back',
                    onPressed: () {
                      $navigate.back();
                    },
                    child: Icon(Icons.arrow_back,
                        size: 24.sp, color: $styles.colors.black),
                  ),
                ),
              ),
        Positioned(
          bottom: 1,
          child: Image.asset(
            AppAsset.bigSmile,
          ),
        ),
      ],
    );
  }
}
