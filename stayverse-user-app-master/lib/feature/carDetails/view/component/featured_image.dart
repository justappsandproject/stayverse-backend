import 'package:stayverse/core/commonLibs/common_libs.dart';

class FeatureItem extends StatelessWidget {
  final String feature;

  const FeatureItem({
    super.key,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      feature,
      style: $styles.text.body.copyWith(
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
