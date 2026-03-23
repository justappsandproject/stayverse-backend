import 'package:stayverse/core/commonLibs/common_libs.dart';

class FeatureItem extends StatelessWidget {
  final String imageAsset;
  final String text;

  const FeatureItem({
    super.key,
    required this.imageAsset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            radius: 16,
            child: SvgPicture.asset(
              imageAsset,
              height: 18,
              width: 18,
            ),
          ),
          const Gap(10),
          Text(
            text,
            style: $styles.text.body.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
