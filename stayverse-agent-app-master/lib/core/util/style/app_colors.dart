import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/color/color_styles.dart';
import 'package:stayvers_agent/core/util/style/dark_theme_colors.dart';
import 'package:stayvers_agent/core/util/style/light_theme_colors.dart';

class AppColors {
  AppColors();
  final Color greyMedium = const Color(0xFF9D9995);
  ColorStyles get light => LightThemeColors();

  ColorStyles get dark => DarkThemeColors();

  ColorStyles getThemeColor(bool isDarkTheme) {
    return isDarkTheme ? DarkThemeColors() : LightThemeColors();
  }

  ColorStyles themeColor(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? DarkThemeColors() : LightThemeColors();
  }

  static const Color black = Color(0xFF2C2C2C);
  static const Color black0C = Color(0xFF0C0C0C);
  static const Color black80C = Color(0xFF02080C);
  static const Color black42 = Color(0xFF424242);
  static const Color brown28 = Color(0xFF373328);
  static const Color brown50 = Color(0xFF7C7450);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyD9 = Color(0xFFD9D9D9);
  static const Color grey5F = Color(0xFF575C5F);
  static const Color grey8F = Color(0xFF8F8F8F);
  static const Color greyD6 = Color(0xFFD1D1D6);
  static const Color grey61 = Color(0xFF616161);
  static const Color greyB9 = Color(0xFF9B9999);
  static const Color greyF7 = Color(0xFFF7F7F7);
  static const Color greyF4 = Color(0xFFF4F4F4);
  static const Color greyF2 = Color(0xFFF2F2F2);
  static const Color grey81 = Color(0xFF818181);
  static const Color grey8D = Color(0xFF898A8D);
  static const Color grey8B = Color(0xFF8B8B8B);
  static const Color grey0D = Color(0xFFE2E0DD);
  static const Color greyE7 = Color(0xFFE7E7E7);
  static const Color grey97 = Color(0xFF979797);
  static const Color primaryyellow = Color(0xFFFBC036);
  static const Color yellowD7 = Color(0xFFFEF2D7);
  static const Color yellowB7 = Color(0xFFFDE8B7);
  static const Color yellowC9 = Color(0xFFFDEDC9);
  static const Color yellow95 = Color(0xFFFFDF95);
  static const Color blue50 = Color(0xFF263F50);
  static const Color blueC7 = Color(0xFFAAC7FF);
  static const Color blueBF = Color(0xFFAFEBFF);
  static const Color pinkAA = Color(0xFFFFAAAA);
  static const Color creamDA = Color(0xFFFFDDAA);
  static const Color purpleCF = Color(0xFFCFAAFF);
  static const Color purpleEA = Color(0xFFEEAAFF);
  final Color tertiary = Colors.white;
  final Color offWhite = const Color(0xFFF8ECE5);
  final Color whiteColor = const Color(0xFFFFFFFF);
  final Color blackColor = const Color(0xFF000000);

  final Color caption = const Color(0xFF7D7873);
  final Color body = const Color(0xFF514F4D);
  final Color greyStrong = const Color(0xFF272625);
  final Color lightGrey = const Color(0xFFF2F2F2);
}
