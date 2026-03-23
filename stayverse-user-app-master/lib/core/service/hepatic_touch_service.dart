import 'package:stayverse/core/util/app/platform_info.dart';
import 'package:flutter/services.dart';

class HapticsFeedbackService {
  static void buttonPress() {
    if (PlatformInfo.isAndroid) {
      lightImpact();
    }
  }

  static Future<void> lightImpact() {
    return HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() {
    return HapticFeedback.mediumImpact();
  }

  static Future<void> heavyImpact() {
    return HapticFeedback.heavyImpact();
  }

  static Future<void> selectionClick() {
    return HapticFeedback.selectionClick();
  }

  static Future<void> vibrate() {
    return HapticFeedback.vibrate();
  }
}
