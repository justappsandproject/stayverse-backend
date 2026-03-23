// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/util/style/app_colors.dart';

export 'app_colors.dart';

@immutable
class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }
    final shortestSide = screenSize.shortestSide;
    const tabletXl = 1000;
    const tabletLg = 800;
    const tabletSm = 600;
    const phoneLg = 400;
    if (shortestSide > tabletXl) {
      scale = 1.25;
    } else if (shortestSide > tabletLg) {
      scale = 1.15;
    } else if (shortestSide > tabletSm) {
      scale = 1;
    } else if (shortestSide > phoneLg) {
      scale = .9; // phone
    } else {
      scale = .85; // small phone
    }
  }

  late final double scale;

  /// The current theme colors for the app
  final AppColors colors = AppColors();

  /// Rounded edge corner radii
  late final _Corners corners = _Corners();

  late final _Shadows shadows = _Shadows();

  /// Padding and margin values
  late final _Insets insets = _Insets(scale);

  /// Text styles
  late final _Text text = _Text(scale);

  /// Animation Durations
  final _Times times = _Times();

  /// Shared sizes
  late final _Sizes sizes = _Sizes();
}

@immutable
class _Text {
  _Text(this._scale);

  final double _scale;

  TextStyle get allFonts => const TextStyle(fontFamily: Constant.montreal);

  late final TextStyle dropCase =
      _createFont(allFonts, sizePx: 56, heightPx: 20);

  late final TextStyle h1 = _createFont(allFonts, sizePx: 64, heightPx: 62);
  late final TextStyle h2 = _createFont(allFonts, sizePx: 32, heightPx: 46);
  late final TextStyle h3 =
      _createFont(allFonts, sizePx: 24, heightPx: 36, weight: FontWeight.w600);
  late final TextStyle h4 = _createFont(allFonts,
      sizePx: 14, heightPx: 23, spacingPc: 5, weight: FontWeight.w600);

  late final TextStyle title1 =
      _createFont(allFonts, sizePx: 16, heightPx: 26, spacingPc: 5);
  late final TextStyle title2 =
      _createFont(allFonts, sizePx: 14, heightPx: 16.38);

  late final TextStyle body = _createFont(allFonts, sizePx: 16, heightPx: 26);
  late final TextStyle bodyBold =
      _createFont(allFonts, sizePx: 16, heightPx: 26, weight: FontWeight.w600);
  late final TextStyle bodySmall =
      _createFont(allFonts, sizePx: 14, heightPx: 23);
  late final TextStyle bodySmallBold =
      _createFont(allFonts, sizePx: 14, heightPx: 23, weight: FontWeight.w600);

  late final TextStyle quote1 = _createFont(allFonts,
      sizePx: 32, heightPx: 40, weight: FontWeight.w600, spacingPc: -3);
  late final TextStyle quote2 =
      _createFont(allFonts, sizePx: 21, heightPx: 32, weight: FontWeight.w400);
  late final TextStyle quote2Sub =
      _createFont(body, sizePx: 16, heightPx: 40, weight: FontWeight.w400);

  late final TextStyle caption =
      _createFont(allFonts, sizePx: 14, heightPx: 20, weight: FontWeight.w500)
          .copyWith(fontStyle: FontStyle.italic);

  late final TextStyle callout =
      _createFont(allFonts, sizePx: 16, heightPx: 26, weight: FontWeight.w600)
          .copyWith(fontStyle: FontStyle.italic);

  late final TextStyle btn = _createFont(allFonts,
      sizePx: 14, weight: FontWeight.w500, spacingPc: 2, heightPx: 14);

  get titleBold => null;

  TextStyle _createFont(TextStyle style,
      {required double sizePx,
      double? heightPx,
      double? spacingPc,
      FontWeight? weight}) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
        fontSize: sizePx,
        height: heightPx != null ? (heightPx / sizePx) : style.height,
        letterSpacing:
            spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
        fontWeight: weight);
  }
}

@immutable
class _Times {
  final Duration fast = const Duration(milliseconds: 300);
  final Duration med = const Duration(milliseconds: 600);
  final Duration slow = const Duration(milliseconds: 900);
  final Duration pageTransition = const Duration(milliseconds: 200);
  final Duration noTransition = const Duration(milliseconds: 0);
}

@immutable
class _Corners {
  late final double zero = 1;
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

class _Sizes {
  double get maxContentWidth1 => 800;

  double get maxContentWidth2 => 600;

  double get maxContentWidth3 => 500;

  final Size minBtnSize = Size(0.8.sw, 50.h);

  final Size fillScreenSize = Size(0.9.sw, 50.h);

  final Size minAppSize = const Size(380, 675);

  final Size gif = const Size(300, 300);
}

@immutable
class _Insets {
  _Insets(this._scale);

  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

@immutable
class _Shadows {
  final textSoft = [
    Shadow(
        color: Colors.black.withOpacity(.25),
        offset: const Offset(0, 2),
        blurRadius: 4),
  ];
  final text = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 2),
        blurRadius: 2),
  ];
  final textStrong = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 4),
        blurRadius: 6),
  ];
  final cardShadow = <BoxShadow>[
    BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(12, 12),
        blurRadius: 1),
  ];

  final mapBottomDetailsShadow = <BoxShadow>[
    BoxShadow(
        color: Colors.black.withOpacity(.19),
        offset: const Offset(0, 1.5),
        blurRadius: 3.5),
  ];

  final successShadow = <BoxShadow>[
    BoxShadow(
        color: Colors.greenAccent.withOpacity(.5),
        offset: const Offset(0, 2),
        spreadRadius: 1,
        blurRadius: 0.9),
  ];
}
