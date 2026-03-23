import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/style/app_style.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class DeleteApartmentDialog extends ConsumerWidget {
  const DeleteApartmentDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Apartment 🚨',
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text('Are you sure you want to delete this apartment?',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                fontSize: 14.5.sp,
              )),
          const Gap(14),
          Row(
            children: [
              Expanded(
                child: AppBtn(
                  onPressed: () {
                    $navigate.back();
                  },
                  semanticLabel: '',
                  bgColor: AppColors.greyB9,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  borderRadius: 15,
                  child: Text('No',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 16.sp)),
                ),
              ),
              const Gap(10),
              Expanded(
                child: AppBtn(
                  onPressed: () {
                    $navigate.back();
                    _deleteApartment();
                  },
                  semanticLabel: '',
                  bgColor: Colors.red,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  borderRadius: 15,
                  child: Text('Yes',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _deleteApartment() {}
}
