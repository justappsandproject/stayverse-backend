import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

class SelfieHeader extends StatelessWidget {
  const SelfieHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          onPressed: () {
            $navigate.back();
          },
          color: $styles.colors.blackColor,
          icon: const Icon(Icons.close),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 48),
            child: Text(
              'Quick Selfie',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: $styles.colors.blackColor,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
