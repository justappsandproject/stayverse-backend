import 'dart:ui';

import 'package:stayverse/core/util/color/base_color_style.dart';

abstract class ColorStyles extends BaseColorStyles {
  // general
  @override
  Color get background;

  Color get foreground;

  @override
  Color get primaryContent;

  @override
  Color get primaryAccent;

  Color get secondary;

  Color get textColor;

  Color get onSecondary;

  @override
  Color get surfaceBackground;
  @override
  Color get surfaceContent;

  // app bar
  @override
  Color get appBarBackground;
  @override
  Color get appBarPrimaryContent;

  // buttons
  @override
  Color get buttonBackground;
  @override
  Color get buttonPrimaryContent;

  // bottom tab bar
  @override
  Color get bottomTabBarBackground;

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected;
  @override
  Color get bottomTabBarIconUnselected;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected;
  @override
  Color get bottomTabBarLabelSelected;
}
