import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class SelfieInstruction extends StatelessWidget {
  const SelfieInstruction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Text(
              'Follow this guideline below',
              textAlign: TextAlign.start,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                  height: 1.2,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationColor: $styles.colors.greyMedium,
                  color: $styles.colors.greyMedium,
                  fontSize: 14.8.sp),
            ),
            const Gap(20),
            const InstructionTile(
                title: 'Bright Lighting',
                subTitle:
                    'Ensure you’re in a well-lit area so your face appears clear and easy to see.',
                icons: AppIcons.bright_light),
            const Gap(10),
            const InstructionTile(
                title: 'Clear Photo',
                subTitle:
                    'Keep your phone steady to capture a sharp, focused image. Avoid blurry shots.',
                icons: AppIcons.clear_photo),
            const Gap(10),
            const InstructionTile(
                title: 'No Face Coverings',
                subTitle:
                    'Remove anything covering your face, such as glasses, masks, hats, or scarves.',
                icons: AppIcons.face_cover),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}

class InstructionTile extends StatelessWidget {
  const InstructionTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icons});

  final String title;

  final String subTitle;

  final AppIcons icons;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppIcon(
          icons,
          size: 35,
          color: $styles.colors.blackColor,
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: $styles.text.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: $styles.colors.blackColor,
                    fontSize: 16.sp),
              ),
              Text(
                subTitle,
                textAlign: TextAlign.start,
                style: $styles.text.bodySmall.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    color: $styles.colors.greyMedium,
                    fontSize: 12.sp),
              ),
            ],
          ),
        )
      ],
    );
  }
}
