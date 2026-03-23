import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/color/color_styles.dart';
import 'package:stayverse/core/util/style/dark_theme_colors.dart';
import 'package:stayverse/core/util/style/light_theme_colors.dart';

class AppColors {
  AppColors();

  final Color tertiary = Colors.white;
  final Color offWhite = const Color(0xFFF8ECE5);
  final Color white = const Color(0xFFFFFFFF);

  final Color black = const Color(0xFF000000);
  final Color caption = const Color(0xFF7D7873);
  final Color body = const Color(0xFF514F4D);
  final Color greyStrong = const Color(0xFF272625);
  final Color greyMedium = const Color(0xFF9D9995);
  final Color lightGrey = const Color(0xFFF2F2F2);
  final Color black0C = const Color(0xFF0C0C0C);
  final Color black80C = const Color(0xFF02080C);
  final Color black42 = const Color(0xFF424242);
  final Color brown28 = const Color(0xFF373328);
  final Color brown50 = const Color(0xFF7C7450);
  final Color greyD9 = const Color(0xFFD9D9D9);
  final Color grey5F = const Color(0xFF575C5F);
  final Color grey8F = const Color(0xFF8F8F8F);
  final Color greyD6 = const Color(0xFFD1D1D6);
  final Color grey61 = const Color(0xFF616161);
  final Color greyB9 = const Color(0xFF9B9999);
  final Color greyF7 = const Color(0xFFF7F7F7);
  final Color greyF4 = const Color(0xFFF4F4F4);
  final Color greyF2 = const Color(0xFFF2F2F2);
  final Color grey81 = const Color(0xFF818181);
  final Color grey8D = const Color(0xFF898A8D);
  final Color grey8B = const Color(0xFF8B8B8B);
  final Color grey0D = const Color(0xFFE2E0DD);
  final Color greyE7 = const Color(0xFFE7E7E7);
  final Color grey97 = const Color(0xFF979797);
  ColorStyles get light => LightThemeColors();

  ColorStyles get dark => DarkThemeColors();

  ColorStyles getThemeColor(bool isDarkTheme) {
    return isDarkTheme ? DarkThemeColors() : LightThemeColors();
  }

  ColorStyles themeColor(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? DarkThemeColors() : LightThemeColors();
  }
}
