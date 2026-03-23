import 'package:stayverse/core/util/color/color_styles.dart';

import 'package:flutter/material.dart';

/* Light Theme Colors
|-------------------------------------------------------------------------- */

class LightThemeColors implements ColorStyles {
  // general
  @override
  Color get background => const Color(0xFFFFFFFF);

  @override
  Color get foreground => const Color(0xFF232c33);

  @override
  Color get secondary => const Color(0xFFE1E1E1);

  @override
  Color get onSecondary => const Color(0xFFE1E1E1);

  @override
  Color get primaryAccent => const Color(0xFFFBC036);

  @override
  Color get primaryContent => Colors.white;

  @override
  Color get textColor => const Color(0xFF2C2C2C);

  @override
  Color get surfaceBackground => Colors.white;
  @override
  Color get surfaceContent => Colors.black;

  // app bar
  @override
  Color get appBarBackground => const Color(0xFF232c33);
  @override
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  @override
  Color get buttonBackground => const Color(0xFF011369);
  @override
  Color get buttonPrimaryContent => Colors.white;

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => Colors.white;

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => const Color(0xFF232c33);
  @override
  Color get bottomTabBarIconUnselected => Colors.black54;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.black45;
  @override
  Color get bottomTabBarLabelSelected => Colors.black;
}
