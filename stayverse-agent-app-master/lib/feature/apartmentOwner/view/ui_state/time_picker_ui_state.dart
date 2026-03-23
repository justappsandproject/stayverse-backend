// Time Picker State Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';

import '../../controller/apartment_advert_notifier.dart';

final createApartmentTimePicker = StateNotifierProvider<TimePickerNotifier, TimePickerState>((ref) {
  return TimePickerNotifier(ref, ProviderMode.create);
});

final editApartmentTimePicker = StateNotifierProvider<TimePickerNotifier, TimePickerState>((ref) {
  return TimePickerNotifier(ref, ProviderMode.edit);
});

// State Notifier
class TimePickerNotifier extends StateNotifier<TimePickerState> {
  TimePickerNotifier(this.ref, this.mode) : super(TimePickerState());

  final Ref ref;
  final ProviderMode mode;

  void selectTime(BuildContext context, bool isCheckIn) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime != null) {
    state = isCheckIn
        ? state.copyWith(checkInTime: pickedTime)
        : state.copyWith(checkOutTime: pickedTime);

    // Convert TimeOfDay to DateTime (using today’s date)
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
    final isoFormatted = dateTime.toUtc().toIso8601String();

  final apartmentAdvert = mode == ProviderMode.create
            ? createApartmentAdvert
            : editApartmentAdvert;

    if (isCheckIn) {
        
      ref.read(apartmentAdvert.notifier).checkInController.text = isoFormatted;
    } else {
      ref.read(apartmentAdvert.notifier).checkOutController.text = isoFormatted;
    }
  }
}

  void setTimes({TimeOfDay? checkIn, TimeOfDay? checkOut}) {
    state = state.copyWith(
      checkInTime: checkIn ?? state.checkInTime,
      checkOutTime: checkOut ?? state.checkOutTime,
    );
  }
}

// State Model
class TimePickerState {
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;

  TimePickerState({this.checkInTime, this.checkOutTime});

  TimePickerState copyWith({TimeOfDay? checkInTime, TimeOfDay? checkOutTime}) {
    return TimePickerState(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }
}