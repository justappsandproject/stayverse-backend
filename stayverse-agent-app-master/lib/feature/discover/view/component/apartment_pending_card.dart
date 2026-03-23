import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class ApartmentPendingCard extends StatelessWidget {
  final Booking? pendingAds;
  const ApartmentPendingCard({
    super.key,
    this.pendingAds,
  });

  @override
  Widget build(BuildContext context) {
    // Add null check and provide default values
    final apartmentName =
        pendingAds?.apartment?.apartmentName ?? 'Unknown Property';
    final address = pendingAds?.apartment?.address ?? 'Unknown Location';
    final pricePerDay = pendingAds?.apartment?.pricePerDay ?? 0;
    final apartmentImages = pendingAds?.apartment?.apartmentImages;

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
              child: apartmentImages != null && apartmentImages.isNotEmpty
                  ? Image.network(
                      apartmentImages.first,
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
            // Add Expanded to prevent overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                apartmentName.txt10(
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
                    text: '₦${_formatPrice(pricePerDay)}',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(
                        text: '/night',
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

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    } else {
      return price.toString();
    }
  }
}
