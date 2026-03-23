import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/buttons.dart';

class CancelBookingsDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const CancelBookingsDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Cancelling Booking?',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text('Are you sure you would like to cancel this booking?',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14.sp)),
          const Gap(14),
          AppBtn(
            onPressed: () {
              $navigate.back();
            },
            semanticLabel: '',
            bgColor: Colors.black,
            expand: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            borderRadius: 15,
            child: Text('No',
                style: $styles.text.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.sp)),
          ),
          const Gap(10),
          AppBtn(
            onPressed: () {
              onConfirm();
            },
            semanticLabel: '',
            bgColor: Colors.grey.shade400,
            expand: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            borderRadius: 15,
            child: Text('Yes, please',
                style: $styles.text.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }
}
