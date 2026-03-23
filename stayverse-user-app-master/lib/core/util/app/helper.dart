import 'dart:async';
import 'dart:convert';

import 'package:open_store/open_store.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/service/BrimDecoders/brim_decoders.dart';
import 'package:stayverse/core/service/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

bool isEmpty(String? val) {
  return (val == null) || (val.trim().isEmpty);
}

bool isNotEmpty(String? val) {
  return !isEmpty(val);
}

Map<String, dynamic> removeNullFromMap(Map<String, dynamic> parameters) {
  final Map<String, dynamic> filtered = <String, dynamic>{};
  parameters.forEach((String key, dynamic value) {
    if (value != null) {
      filtered[key] = value;
    }
  });
  return filtered;
}

isObjectEmpty(dynamic val) {
  if (val is Map) return val.isEmpty;
  if (val is List) return val.isEmpty;

  return (val == null);
}

isObjectNotEmpty(dynamic val) {
  return !isObjectEmpty(val);
}

closKeyPad(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String concatenateBase64(String path, String encodedValue) {
  final String fileName = path.split('/').last;
  final String ext = fileName.split('.').last;
  String prefix = 'data:image/$ext;base64,';
  String base64 = prefix + encodedValue;
  return base64;
}

BuildContext? overlayContext(GlobalKey<NavigatorState>? key) {
  if (key == null) return null;
  BuildContext? overlay;
  key.currentState?.overlay?.context.visitChildElements((element) {
    overlay = element;
  });
  return overlay;
}




Future<void> launchStore() async {
  await OpenStore.instance.open(
    appStoreId: Constant.iosId,
    androidAppBundleId: Constant.androidId, 
  );
}
String getFileSizeInMB(var byeInLength) {
  double kb = byeInLength / 1024;
  return (kb / 1024).toString();
}

String getFileSizeInKb(var byeInLength) {
  double kb = byeInLength / 1024;
  return kb.toString();
}

T dataToModel<T>({required dynamic data, Map<Type, dynamic>? modelDecoders}) {
  return BrimDecoders.dataToModel<T>(data: data, modelDecoders: modelDecoders);
}

String? convertMoneyToString(dynamic value) {
  try {
    return double.parse((value as String).replaceAll(',', '')).toString();
  } on FormatException catch (_) {
    return null;
  }
}

void copyAccountNumber(String? accountNumber) {
  if (isNotEmpty(accountNumber)) {
    AppClipboard.copy(accountNumber ?? '');

    BrimToast.showSuccess('Account Number Copied', title: 'Copied!');
  }
}

void copyToClipBoard(String? code) {
  if (isNotEmpty(code)) {
    AppClipboard.copy(code ?? '');

    BrimToast.showSuccess('Wallet Address Copied', title: 'Copied!');
  }
}

String? moneyConverter(String? amount, {String? defaultPrice}) {
  amount ??= defaultPrice ?? '0.00';

  double convertAmount;
  try {
    convertAmount = double.parse(amount);
  } on Exception catch (_) {
    return amount;
  }
  return formatAmount(convertAmount);
}

String userName(String? value) {
  return value?.trim().split(' ')[0] ?? 'Guest';
}

String? formatAmount(double? amount) {
  MoneyFormatter fmf = MoneyFormatter(amount: amount ?? 0);
  return fmf.output.nonSymbol;
}

String getNameOnIndex(String? name, {int index = 0}) {
  if (name == null) {
    return '';
  }
  List nameList = name.split(' ');

  if (nameList.contains('')) {
    nameList.removeWhere((element) => element == '');
  }

  if (index > (nameList.length) - 1) {
    return '';
  }

  if (nameList.length >= index) {
    return nameList[index];
  }
  return name;
}

bool isInteger(String? s) {
  if (s == null) {
    return false;
  }

  RegExp regExp = RegExp(
    r"^-?[0-9]+$",
    caseSensitive: false,
    multiLine: false,
  );

  return regExp.hasMatch(s);
}

bool isDouble(String? s) {
  if (s == null) {
    return false;
  }

  RegExp regExp = RegExp(
    r"^[0-9]{1,13}([.]?[0-9]*)?$",
    caseSensitive: false,
    multiLine: false,
  );

  return regExp.hasMatch(s);
}

bool isValueInt(String? string) {
  if (isEmpty(string)) {
    return false;
  }
  return int.tryParse(string!) != null;
}

FutureOr<dynamic> decodeJson(String text) {
  if (text.codeUnits.length < 50 * 1024) {
    return jsonDecode(text);
  }

  return compute(jsonDecode, text);
}

void openPhoneNumber({required String? number}) async {
  if (isEmpty(number)) return;

  if (await launchUrl(Uri.parse('tel:$number'))) {
  } else {
  }
}

void openEmail(String email) async {
  if (await launchUrl(Uri.parse('mailto:$email'))) {
  } else {}
}

String buildFullName(String? firstName, String? lastName) {
  final first = firstName?.trim() ?? '';
  final last = lastName?.trim() ?? '';

  if (first.isEmpty && last.isEmpty) {
    return '';
  } else if (first.isEmpty) {
    return last;
  } else if (last.isEmpty) {
    return first;
  } else {
    return '$first $last';
  }
}

void openChatSupport(String chatSupport) async {
  if (await launchUrl(Uri.parse('chat:$chatSupport'))) {
  } else {}
}

void openAboutUs(String aboutUs) async {
  if (await launchUrl(Uri.parse(aboutUs))) {
  } else {}
}
