import 'package:stayverse/core/commonLibs/common_libs.dart';

class PickUpLocationContainer extends StatelessWidget {
  final String? pickupAddress;
  const PickUpLocationContainer({
    super.key,
    this.pickupAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 20, color: Color(0xFFF2A900)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pickupAddress ?? 'No pickup address available',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: $styles.text.title1.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF898A8D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}