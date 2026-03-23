import 'package:intl/intl.dart';

String formatCurrencySmart(
  num value, {
  bool isEarnings = false,
}) {
  if (value == 0) {
    return isEarnings ? '0.00' : '0';
  }

  final numberFormat = NumberFormat('#,##0');

  if (value >= 1000000000) {
    final result = value / 1000000000;
    return '${_trimDecimals(result)}B';
  }

  if (value >= 1000000) {
    final result = value / 1000000;
    return '${_trimDecimals(result)}M';
  }

  if (value >= 1000) {
    return numberFormat.format(value);
  }

  return value.toString();
}

String _trimDecimals(num value) {
  final formatted = value.toStringAsFixed(2);

  return formatted.endsWith('.00')
      ? formatted.replaceAll('.00', '')
      : formatted
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
}


