// section_header.dart
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onTapViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: $styles.text.bodySmall.copyWith(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: onTapViewAll,
          child: Text(
            'View all',
            style: $styles.text.bodySmall.copyWith(
              color: context.color.primary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
