import 'package:stayverse/core/commonLibs/common_libs.dart';

class BookingAmountSection extends StatelessWidget {
  final String? name;

  const BookingAmountSection({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Booking Confirmed',
          style: $styles.text.body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Gap(5),
        Text(
          'Great news! You have successfully booked ${name != null ? "\"$name\"" : "this apartment"}.The agent is now confirming your booking.:',
          textAlign: TextAlign.center,
          style: $styles.text.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
