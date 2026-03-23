import 'package:shimmer/shimmer.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class InfoCardComponent extends StatelessWidget {
  final String title, digit;
  final String? backgroundImagePath;
  final Color backgroundColor, txtColor, digitColor, borderColor, iconColor;
  final AppIcons icon;
  final double width;
  final bool isLoading;

  const InfoCardComponent({
    super.key,
    required this.digit,
    this.backgroundImagePath,
    this.backgroundColor = AppColors.black,
    this.borderColor = Colors.transparent,
    this.width = double.infinity,
    required this.title,
    this.txtColor = AppColors.white,
    this.digitColor = AppColors.primaryyellow,
    this.iconColor = AppColors.white,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Optional Background Image
          if (backgroundImagePath != null)
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: SvgPicture.asset(
                backgroundImagePath!,
                fit: BoxFit.contain,
              ),
            ),

          // Content
          Padding(
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title.txt(
                      size: 17,
                      fontWeight: FontWeight.w500,
                      color: txtColor,
                    ),
                    AppIcon(
                      icon,
                      color: iconColor,
                    ),
                  ],
                ),
                20.sbH,
                _buildDigitDisplay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitDisplay() {
    if (isLoading) {
      return Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade600,
            highlightColor: Colors.grey.shade400,
            child: Container(
              width: 80,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      );
    } else {
      return  Text(
              digit,
              style: $styles.text.body.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: digitColor,
              ),
            );
    }
  }
}
