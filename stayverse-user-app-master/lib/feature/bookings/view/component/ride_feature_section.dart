import 'package:stayverse/core/commonLibs/common_libs.dart';

class RideFeaturesSection extends StatefulWidget {
  final List<String> features;

  const RideFeaturesSection({
    super.key,
    required this.features,
  });

  @override
  State<RideFeaturesSection> createState() => _RideFeaturesSectionState();
}

class _RideFeaturesSectionState extends State<RideFeaturesSection>
    with SingleTickerProviderStateMixin {
  bool showAllFeatures = false;

  @override
  Widget build(BuildContext context) {
    final features = widget.features;
    final visibleFeatures =
        showAllFeatures ? features : features.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ride Features',
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(10),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: visibleFeatures.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  feature,
                  style: $styles.text.body.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.features.length > 6) ...[
          const Gap(10),
          GestureDetector(
            onTap: () {
              setState(() => showAllFeatures = !showAllFeatures);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  showAllFeatures ? 'Show less features' : 'Show all features',
                  style: $styles.text.body.copyWith(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
