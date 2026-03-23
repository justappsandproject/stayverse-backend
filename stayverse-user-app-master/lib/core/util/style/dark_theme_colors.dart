import 'package:stayverse/core/util/color/color_styles.dart';
import 'package:flutter/material.dart';

/* Dark Theme Colors
|-------------------------------------------------------------------------- */

class DarkThemeColors implements ColorStyles {
  // general
  @override
  Color get background => const Color(0xFF232c33);

  @override
  Color get foreground => const Color(0xFFE1E1E1);

  @override
  Color get secondary => const Color(0xFFFF5303);

  @override
  Color get onSecondary => const Color(0xFFE1E1E1);

  @override
  Color get primaryAccent => const Color(0xFF011369);

  @override
  Color get primaryContent => const Color(0xFFE1E1E1);

  @override
  Color get surfaceBackground => Colors.white70;

  @override
  Color get surfaceContent => Colors.black;

  // app bar
  @override
  Color get appBarBackground => const Color(0xFF4b5e6d);

  @override
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  @override
  Color get buttonBackground => Colors.white60;
  @override
  Color get buttonPrimaryContent => const Color(0xFF232c33);

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => const Color(0xFF232c33);

  // text color
  @override
  Color get textColor => Colors.white;

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => Colors.white70;
  @override
  Color get bottomTabBarIconUnselected => Colors.white60;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.white54;
  @override
  Color get bottomTabBarLabelSelected => Colors.white;
}
