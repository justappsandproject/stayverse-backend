
import 'package:stayverse/core/commonLibs/common_libs.dart';

class RideDescriptionSection extends StatelessWidget {
  final String description;

  const RideDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ride Details',
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(10),
        Text(
          description,
          style: $styles.text.body.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

