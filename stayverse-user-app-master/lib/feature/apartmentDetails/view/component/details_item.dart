
import 'package:stayverse/core/commonLibs/common_libs.dart';

class DetailItem extends StatelessWidget {
  final String imageAsset;
  final String text;

  const DetailItem({
    super.key,
    required this.imageAsset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(imageAsset),
          const Gap(2),
          Text(
            text,
            style: $styles.text.body.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }
}
