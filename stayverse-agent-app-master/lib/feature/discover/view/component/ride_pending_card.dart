import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/image_loading_progress.dart';

class RidePendingCard extends StatelessWidget {
  final Booking? pendingAds;
  const RidePendingCard({
    super.key,
    this.pendingAds,
  });

  @override
  Widget build(BuildContext context) {
    // Add null check and provide default values
    final rideName = pendingAds?.ride?.rideName ?? 'Unnamed Ride';
    final address = pendingAds?.ride?.address ?? 'Location not available';
    final pricePerHour = pendingAds?.ride?.pricePerHour ?? 0;

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
              child: Image.network(
                pendingAds?.ride?.rideImages?.firstOrNull ??
                    Constant.defaultApartmentImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 82,
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey.shade200,
                    child: LinearImageLoadingProgress(
                      loadingProgress: loadingProgress,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          17.sbW,
          Expanded(
            // Add Expanded to prevent overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rideName.txt10(
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
                    2.sbW, // Add spacing between icon and text
                    Expanded(
                      // Prevent text overflow
                      child: address.txt(
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
                              pricePerHour.toDouble() ,
                              decimalDigits: 0,
                            ),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: Constant.inter,
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

  // String _formatPrice(int price) {
  //   if (price >= 1000000) {
  //     return '${(price / 1000000).toStringAsFixed(1)}M';
  //   } else if (price >= 1000) {
  //     return '${(price / 1000).toStringAsFixed(0)}k';
  //   } else {
  //     return price.toString();
  //   }
  // }
}
