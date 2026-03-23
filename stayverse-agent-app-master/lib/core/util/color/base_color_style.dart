import 'package:flutter/material.dart';

abstract class BaseColorStyles {
  /// * Available styles *

  // general
  Color get background;
  Color get primaryContent;
  Color get primaryAccent;

  Color get surfaceBackground;
  Color get surfaceContent;

  // app bar
  Color get appBarBackground;
  Color get appBarPrimaryContent;

  // buttons
  Color get buttonBackground;
  Color get buttonPrimaryContent;

  // bottom tab bar
  Color get bottomTabBarBackground;

  // bottom tab bar - icons
  Color get bottomTabBarIconSelected;
  Color get bottomTabBarIconUnselected;

  // bottom tab bar - label
  Color get bottomTabBarLabelUnselected;
  Color get bottomTabBarLabelSelected;
}
