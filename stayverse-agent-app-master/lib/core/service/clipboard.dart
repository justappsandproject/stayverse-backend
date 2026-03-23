import 'package:flutter/services.dart';

class AppClipboard {
  static Future<void> copy(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      return;
    } else {
      return;
    }
  }

  /// Paste retrieves the data from clipboard.
  static Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text?.toString() ?? '';
  }
}
