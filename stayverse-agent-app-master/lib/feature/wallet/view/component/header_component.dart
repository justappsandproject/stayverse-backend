import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/buttons.dart';

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
        SvgPicture.asset(AppAsset.ellipse),
        // Emoji

        useHeader
            ? Positioned(
                top: 20,
                child: SafeArea(
                  child: (headerTxt ?? 'Withdraw Successful').txt20(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
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
                        size: 24.sp, color: AppColors.black),
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
