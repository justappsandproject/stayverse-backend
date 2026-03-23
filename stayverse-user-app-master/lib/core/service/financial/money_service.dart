import 'package:money_formatter/money_formatter.dart';

class MoneyService {
  // Convert from kobo to naira
  static double koboToNaira(int kobo) {
    return kobo / 100.0;
  }

  // Convert from naira to kobo
  static int nairaToKobo(double naira) {
    return (naira * 100).round();
  }

  // Convert from kobo to naira using a string input
  static double? koboToNairaFromString(String koboString) {
    final kobo = int.tryParse(koboString);

    return kobo == null ? null : koboToNaira(kobo);
  }

  // Convert from naira to kobo using a string input
  static int? nairaToKoboFromString(String nairaString) {
    final naira = convertMoneyToDouble(nairaString);

    return naira == null ? null : nairaToKobo(naira);
  }

  static double? convertMoneyToDouble(String value) {
    try {
      return double.parse((value).replaceAll(',', ''));
    } on Exception catch (_) {
      return null;
    }
  }

  static String formatMoney(
    double? amount,
  ) {
    amount ??= 0.0;
    return _addMoneySeperator(amount);
  }

  static String _addMoneySeperator(double? amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount ?? 0);
    return fmf.output.nonSymbol;
  }




}

