import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String startDate, endDate;
  final String state;
  final VoidCallback? onDelete;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.state,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: $styles.text.title2.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            AppBtn(
              onPressed: onDelete,
              semanticLabel: '',
              padding: EdgeInsets.zero,
              bgColor: Colors.transparent,
              child: const AppIcon(
                AppIcons.delete,
                color: Colors.black,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          company,
          style: $styles.text.title2.copyWith(
            fontSize: 12,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateTimeService.formatExperienceRange(
              startDate, endDate), //'$startDate - $endDate',
          style: $styles.text.title2.copyWith(
            fontSize: 12,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          state,
          style: $styles.text.title2.copyWith(
            fontSize: 12,
            color: const Color(0xFF616161),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class LicenseCard extends StatelessWidget {
  final String title;
  final String certName;
  final String issueDate;
  final VoidCallback? onDelete;

  const LicenseCard({
    super.key,
    required this.title,
    required this.certName,
    required this.issueDate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: $styles.text.title2.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            AppBtn(
              onPressed: onDelete,
              semanticLabel: '',
              padding: EdgeInsets.zero,
              bgColor: Colors.transparent,
              child: const AppIcon(
                AppIcons.delete,
                color: Colors.black,
                size: 16,
              ),
            ),
          ],
        ),
        4.sbH,
        certName.txt10(
          fontWeight: FontWeight.w400,
          color: AppColors.grey61,
        ),
        4.sbH,
        'Issued ${DateFormat('MMM. yyyy').format(DateTime.parse(issueDate))}'
            .txt10(
          fontWeight: FontWeight.w400,
          color: AppColors.grey61,
        ),
      ],
    );
  }
}
