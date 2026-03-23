import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/shared/image_loading_progress.dart';

class BookedRideCard extends StatelessWidget {
  final Booking? acceptedAds;
  const BookedRideCard({
    super.key,
    this.acceptedAds,
  });

  @override
  Widget build(BuildContext context) {
    final apartmentName = acceptedAds?.ride?.rideName ?? 'Unnamed Ride';
    final startDate = acceptedAds?.startDate;
    final endDate = acceptedAds?.endDate;

    final dateRange = getFormattedBookingDateRange(startDate, endDate);
    final nights = getNumberOfNights(startDate, endDate);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyD9,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  acceptedAds?.ride?.rideImages?.firstOrNull ??
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
            10.sbW,

            // Booking Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  apartmentName.txt12(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.sbH,
                  dateRange.txt(
                    size: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey5F,
                  ),
                ],
              ),
            ),
            30.sbW,

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'Amount Paid'.txt(
                  size: 8,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                4.sbH,
                MoneyServiceV2.formatNaira(
                        acceptedAds?.totalPrice?.toDouble() ?? 0.0)
                    .txt12(
                  fontFamily: Constant.inter,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryyellow,
                ),
              ],
            ),
            35.sbW,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'No. of Hours:'.txt(
                  size: 8,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                4.sbH,
                '$nights'.txt12(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8F,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getFormattedBookingDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';

    final start = DateFormat("MMM. d'th'", 'en_US').format(startDate);
    final end = DateFormat("MMM. d yyyy", 'en_US').format(endDate);

    return '$start - $end';
  }

  int getNumberOfNights(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return 0;

    return endDate.difference(startDate).inHours;
  }
}
