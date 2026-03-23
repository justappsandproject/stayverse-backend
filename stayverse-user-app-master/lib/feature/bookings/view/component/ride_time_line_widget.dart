import 'package:intl/intl.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/shared/vertical_dash_line.dart';

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
                        Border.all(color: const Color(0xFFFBC036), width: 1),
                    color: isCompleted
                        ? const Color(0xFFFBC036)
                        : Colors.transparent,
                  ),
                ),
                Container(
                  height: 62,
                  margin: const EdgeInsets.only(left: 7),
                  child: const VeriticalDashLine(
                    width: 1,
                    color: Color(0xFFFBC036),
                  ),
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFBC036), width: 1),
                    color: isCompleted
                        ? const Color(0xFFFBC036)
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
                  Text(
                    formatFullDate(checkedIn),
                    style: $styles.text.body.copyWith(
                      fontFamily: Constant.sora,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    (checkedInString ?? 'Checked In'),
                    style: $styles.text.body.copyWith(
                      fontFamily: Constant.sora,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8B8B8B),
                    ),
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
                  Text(
                    formatFullDate(checkedOut),
                    style: $styles.text.body.copyWith(
                      fontFamily: Constant.sora,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    (checkedOutString ?? 'Checked Out'),
                    style: $styles.text.body.copyWith(
                      fontFamily: Constant.sora,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8B8B8B),
                    ),
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
