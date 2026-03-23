import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/wallet/model/data/bank_response.dart';

class SelectedBank extends StatelessWidget {
  final Bank? data;
  const SelectedBank({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0XFFAAADB7), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                isEmpty(data?.name)
                    ? const SizedBox.shrink()
                    : CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.15),
                        radius: 20.0,
                        child: Center(
                          child: Text(
                            (data?.name ?? "---")
                                .split(" ")
                                .first
                                .substring(0, 2)
                                .toUpperCase(),
                            style: $styles.text.caption.copyWith(
                              fontSize: 15.0,
                              color: Colors.black.withOpacity(0.5),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const Gap(10.0),
                Expanded(
                  child: Text(
                    data?.name ?? 'Select Bank',
                    maxLines: 1,
                    style: $styles.text.body.copyWith(
                      color: data?.name != null
                          ? Colors.black
                          : $styles.colors.greyMedium,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(5),
          const Icon(
            Icons.arrow_drop_down,
            color: AppColors.greyB9,
            size: 28,
          )
        ],
      ),
    );
  }
}
