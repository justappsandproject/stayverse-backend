import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class PaymentInfoCard extends StatelessWidget {
  final Booking? booking;
  const PaymentInfoCard({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 23, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          booking?.startDate != null && booking?.endDate != null
              ? Text(
                  DateTimeService.calculateDurationInHours(
                    booking?.startDate,
                    booking?.endDate,
                  ),
                  style: $styles.text.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                )
              : Text(
                  "Not Specified",
                  style: $styles.text.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MoneyServiceV2.formatNaira(
                    booking?.totalPrice?.toDouble() ?? 0),
                style: $styles.text.body.copyWith(
                  fontSize: 12,
                  fontFamily: Constant.inter,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey8D,
                ),
              ),
              Text(
                booking?.paymentStatus ?? '',
                style: $styles.text.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryyellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
