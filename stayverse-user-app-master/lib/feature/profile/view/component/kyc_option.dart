
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';

class KycProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final KycVerificationStatus? kycStatus;

  const KycProfileOption({
    super.key,
    required this.title,
    this.onTap,
    this.kycStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            title,
            style: $styles.text.bodyBold.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (kycStatus != null) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kycStatus!.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                kycStatus!.label,
                style: TextStyle(
                  color: kycStatus!.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey.shade500,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
