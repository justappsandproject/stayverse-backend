import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class ApartmentDetailInfoContainer extends StatelessWidget {
  final AppIcons infoIcon;
  final String info;
  const ApartmentDetailInfoContainer({
    super.key,
    required this.infoIcon,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyF7,
        border: Border.all(color: AppColors.greyF4),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            infoIcon,
            size: 16,
          ),
          6.sbW,
          info.txt12(
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          )
        ],
      ),
    );
  }
}
