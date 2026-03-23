import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/style/app_style.dart';

class AppTheme {
  static ThemeData toThemeData({
    required AppStyle styles,
    bool isDark = false,
  }) {
    final colorStyle = styles.colors.getThemeColor(isDark);

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: colorStyle.primaryAccent,
      scaffoldBackgroundColor: colorStyle.background,
      cardColor: colorStyle.surfaceBackground,

      // Text Theme
      textTheme: TextTheme(
        displayLarge: styles.text.h1.copyWith(color: colorStyle.primaryContent),
        displayMedium:
            styles.text.h2.copyWith(color: colorStyle.primaryContent),
        displaySmall: styles.text.h3.copyWith(color: colorStyle.primaryContent),
        headlineMedium:
            styles.text.h4.copyWith(color: colorStyle.primaryContent),
        bodyLarge: styles.text.body.copyWith(color: colorStyle.primaryContent),
        bodyMedium: styles.text.body.copyWith(color: colorStyle.primaryContent),
        bodySmall:
            styles.text.bodySmall.copyWith(color: colorStyle.primaryContent),
      ).apply(
        fontFamily: 'Inter',
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorStyle.primaryAccent,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colorStyle.secondary,
          foregroundColor: colorStyle.onSecondary,
        ),
      ),

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        // Primary colors
        primary: colorStyle.primaryAccent,
        onPrimary: colorStyle.primaryContent,
        primaryContainer: colorStyle.primaryAccent.withValues(alpha: 0.8),
        onPrimaryContainer: colorStyle.primaryContent,

        // Secondary colors
        secondary: colorStyle.secondary,
        onSecondary: colorStyle.onSecondary,
        secondaryContainer: colorStyle.secondary.withValues(alpha: 0.8),
        onSecondaryContainer: colorStyle.onSecondary,

        // Tertiary colors
        tertiary: colorStyle.secondary.withValues(alpha: 0.7),
        onTertiary: colorStyle.onSecondary,
        tertiaryContainer: colorStyle.secondary.withValues(alpha: 0.6),
        onTertiaryContainer: colorStyle.onSecondary,

        // Surface colors
        surface: colorStyle.surfaceBackground,
        onSurface: colorStyle.surfaceContent,

        onSurfaceVariant: colorStyle.surfaceContent,
        surfaceTint: colorStyle.primaryAccent.withValues(alpha: 0.1),

        // Error colors
        error: Colors.red,
        onError: Colors.white,
        errorContainer: Colors.red.shade700,
        onErrorContainer: Colors.white,

        // Additional semantic colors
        outline: colorStyle.primaryAccent.withValues(alpha: 0.4),
        outlineVariant: colorStyle.primaryAccent.withValues(alpha: 0.2),
        shadow: Colors.black.withValues(alpha: 0.1),
        scrim: Colors.black.withValues(alpha: 0.3),
        inverseSurface: colorStyle.foreground,
        onInverseSurface: colorStyle.background,
        inversePrimary: colorStyle.primaryContent,
      ),
    );
  }
}
