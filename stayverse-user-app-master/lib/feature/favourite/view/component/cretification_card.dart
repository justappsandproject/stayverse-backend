import 'package:intl/intl.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

class LicenseCard extends StatelessWidget {
  final String title;
  final String certName;
  final String issueDate;

  const LicenseCard({
    super.key,
    required this.title,
    required this.certName,
    required this.issueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: $styles.text.title2.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(4),
        Text(
          certName,
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF616161),
          ),
        ),
        const Gap(4),
        Text(
          'Issued ${DateFormat('MMM. yyyy').format(DateTime.parse(issueDate))}',
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF616161),
          ),
        ),
      ],
    );
  }
}
