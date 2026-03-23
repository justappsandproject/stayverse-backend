import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class ActiveListingCard extends StatelessWidget {
  final String? title;
  final String? location;
  final int? price;
  final String? image;
  const ActiveListingCard({
    super.key,
    this.title,
    this.location,
    this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 82,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: (image?.isNotEmpty ?? false)
                  ? Image.network(
                      image ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppAsset.shortlet,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppAsset.shortlet,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          17.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (title ?? 'No Name').txt10(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                5.sbH,
                Row(
                  children: [
                    const AppIcon(
                      AppIcons.location,
                      size: 13,
                      color: AppColors.grey8D,
                    ),
                    4.sbW,
                    Expanded(
                      child: (location ?? 'Not Available').txt(
                        size: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey8D,
                      ),
                    ),
                  ],
                ),
                5.sbH,
                Text.rich(
                  TextSpan(
                    text: MoneyServiceV2.formatNaira(
                      price?.toDouble() ?? 0,
                      decimalDigits: 0,
                    ),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(
                        text: '/hr',
                        style: TextStyle(
                          color: AppColors.grey8D,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
