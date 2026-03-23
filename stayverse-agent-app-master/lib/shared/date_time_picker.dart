import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';


void showAppDatePicker(
  BuildContext context, {
  void Function(DateTime)? onChange,
  void Function(DateTime)? onConfirm,
}) {
  final DateTime minDate = DateTime(DateTime.now().year - 100);
  DatePicker.showDatePicker(context,
      showTitleActions: true,
      minTime: minDate,
      locale: LocaleType.en, onChanged: (date) {
    onChange != null ? onChange(date) : null;
  }, onConfirm: (date) {
    onConfirm != null ? onConfirm(date) : null;
  }, currentTime: DateTime.now());
}

void showAppDateTimePicker(
  BuildContext context, {
  void Function(DateTime)? onChange,
  void Function(DateTime)? onConfirm,
}) {
  DatePicker.showDateTimePicker(context,
      showTitleActions: true,
      minTime: DateTime.now(),
      locale: LocaleType.en, onChanged: (date) {
    onChange != null ? onChange(date) : null;
  }, onConfirm: (date) {
    onConfirm != null ? onConfirm(date) : null;
  }, currentTime: DateTime.now());
}
