import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class PlatformInfo {
  bool get isLandscapeEnabled =>
      PlatformInfo.isDesktopOrWeb || deviceSize.shortestSide > 500;

  // Support portrait and landscape on desktop, web and tablets. Stick to portrait for phones.
  // A return value of null indicated both orientations are supported.
  Axis? get supportedOrientations => isLandscapeEnabled ? null : Axis.vertical;

  Size get deviceSize {
    final w = WidgetsBinding.instance.platformDispatcher.views.first;
    return w.physicalSize / w.devicePixelRatio;
  }

  static const _desktopPlatforms = [
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.linux
  ];
  static const _mobilePlatforms = [TargetPlatform.android, TargetPlatform.iOS];

  static bool get isDesktop =>
      _desktopPlatforms.contains(defaultTargetPlatform) && !kIsWeb;
  static bool get isDesktopOrWeb => isDesktop || kIsWeb;
  static bool get isMobile =>
      _mobilePlatforms.contains(defaultTargetPlatform) && !kIsWeb;


  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
}
