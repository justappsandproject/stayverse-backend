import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/time_picker_ui_state.dart';

import '../../controller/apartment_advert_notifier.dart';

class TimePickerWidget extends ConsumerWidget {
  final ProviderMode mode;
  const TimePickerWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartmentTimePicker = mode == ProviderMode.create
        ? createApartmentTimePicker
        : editApartmentTimePicker;
    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    final timeState = ref.watch(apartmentTimePicker);
    final apartmentState = ref.watch(apartmentAdvert);

    if (((apartmentState.checkIn?.isNotEmpty ?? false) ||
            (apartmentState.checkOut?.isNotEmpty ?? false)) &&
        (timeState.checkInTime == null && timeState.checkOutTime == null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final timePicker = ref.read(apartmentTimePicker.notifier);

        if (apartmentState.checkIn?.isNotEmpty ?? false) {
          final dt = DateTime.tryParse(apartmentState.checkIn!);
          if (dt != null) {
            final checkInTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
            timePicker.setTimes(checkIn: checkInTime);
          }
        }

        if (apartmentState.checkOut?.isNotEmpty ?? false) {
          final dt = DateTime.tryParse(apartmentState.checkOut!);
          if (dt != null) {
            final checkOutTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
            timePicker.setTimes(checkOut: checkOutTime);
          }
        }
      });
    }

    Widget buildTimeBox(String label, TimeOfDay? time, bool isCheckIn) {
      final isSelected = time != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.txt14(
            fontWeight: FontWeight.w500,
            color: AppColors.grey8D,
            height: 0,
          ),
          Gap(10.spaceScale),
          GestureDetector(
            onTap: () => ref
                .read(apartmentTimePicker.notifier)
                .selectTime(context, isCheckIn),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellowD7 : AppColors.greyF7,
                border: Border.all(
                  color: isSelected ? AppColors.yellowB7 : AppColors.greyF4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (isSelected ? time.format(context) : '').txt12(
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primaryyellow : AppColors.greyD6,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
            child: buildTimeBox('Check-in time', timeState.checkInTime, true)),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 14,
            height: 1,
            color: AppColors.grey8D,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                buildTimeBox('Check-out time', timeState.checkOutTime, false)),
      ],
    );
  }
}
