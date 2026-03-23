import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
//import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/vertical_dash_line.dart';

class RideTimeLineWidget extends StatelessWidget {
  final bool isCompleted;
  final DateTime? checkedIn;
  final DateTime? checkedOut;
  final String? checkedInString, checkedOutString;

  const RideTimeLineWidget({
    super.key,
    required this.isCompleted,
    this.checkedIn,
    this.checkedOut,
    this.checkedInString,
    this.checkedOutString,
  });

  String formatFullDate(DateTime? dateTime) {
    if (dateTime == null) return 'Date Not Available';

    final date = DateFormat('d MMMM yyyy').format(dateTime); // 12 February 2023
    final time = DateFormat('h:mma').format(dateTime).toLowerCase(); // 11:32pm

    return "$date ($time)";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.primaryyellow, width: 1),
                    color: isCompleted
                        ? AppColors.primaryyellow
                        : Colors.transparent,
                  ),
                ),
                Container(
                  height: 62,
                  margin: const EdgeInsets.only(left: 7),
                  child: const VeriticalDashLine(
                    width: 1,
                    color: AppColors.primaryyellow,
                  ),
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.primaryyellow, width: 1),
                    color: isCompleted
                        ? AppColors.primaryyellow
                        : Colors.transparent,
                  ),
                ),
              ],
            ),

            // Checked In
            Positioned(
              left: 20,
              top: -4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formatFullDate(checkedIn).txt12(
                    fontFamily: Constant.sora,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  (checkedInString ?? 'Checked In').txt12(
                    fontFamily: Constant.sora,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey8B,
                  ),
                ],
              ),
            ),

            // Checked Out
            Positioned(
              left: 20,
              top: 58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formatFullDate(checkedOut).txt12(
                    fontFamily: Constant.sora,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  (checkedOutString ?? 'Checked Out').txt12(
                    fontFamily: Constant.sora,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey8B,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
