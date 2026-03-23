import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/util/color/color_styles.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/style/app_fonts.dart';

// extension DoubleScaleExtension on double {
//   ///Scale the space according to the screen size
//   double get spaceScale => (this * $styles.scale);
// }

// extension IntScaleExtension on int {
//   ///Scale the space according to the screen size
//   double get spaceScale => (this * $styles.scale);
// }

// extension SafeFirst<T> on List<T> {
//   T? get firstOrNull {
//     return isEmpty ? null : first;
//   }
// }
// /// Extension for creating a ValueNotifier from a value directly.
// extension NotifierX<T> on T {
//   ValueNotifier<T> get notifier {
//     return ValueNotifier<T>(this);
//   }
// }

// /// extension for listening to ValueNotifier instances.
// extension NotifierBuilderX<T> on ValueNotifier<T> {
//   Widget sync({
//     required Widget Function(BuildContext context, T value, Widget? child)
//         builder,
//   }) {
//     return ValueListenableBuilder<T>(
//       valueListenable: this,
//       builder: builder,
//     );
//   }
// }

// extension MultiListenableX on List<Listenable> {
//   Widget multiSync({
//     required Widget Function(BuildContext context, Widget? child) builder,
//   }) {
//     return ListenableBuilder(
//       listenable: Listenable.merge(this),
//       builder: builder,
//     );
//   }
// }

// extension ThemeExtension on BuildContext {

//   ColorScheme get color => Theme.of(this).colorScheme;

//   double get dW => MediaQuery.of(this).size.width;

//   double get dH => MediaQuery.of(this).size.height;
// }

extension DoubleScaleExtension on double {
  ///Scale the space according to the screen size
  double get spaceScale => (this * $styles.scale);
}

extension IntScaleExtension on int {
  ///Scale the space according to the screen size
  double get spaceScale => (this * $styles.scale);
}

extension SafeFirst<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;

  ColorStyles get themeColors => $styles.colors.themeColor(this);

  double get dW => MediaQuery.of(this).size.width;

  double get dH => MediaQuery.of(this).size.height;
}

extension WidgetSliverBoxX on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}

extension InkWellExtension on Widget {
  InkWell tap({
    required GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? splashColor = Colors.transparent,
    Color? highlightColor = Colors.transparent,
    String? tooltipMessage,
    BuildContext? context,
    void Function({
      required bool value,
    })? onHover,
  }) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        if (onHover != null) {
          onHover(value: value);
        }
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      splashColor: splashColor,
      highlightColor: highlightColor,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: this,
    );
  }
}

extension StyledTextExtension on String {
  Text txt({
    double? size,
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        fontSize: size ?? 10.spMin,
        // color: color ?? $appKey.currentContext!.color.inverseSurface,
        color: color ?? AppColors.black,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: fontFamily ?? AppFonts.headerFont,
        fontStyle: fontStyle,
        decoration: decoration,
        decorationColor: decorationColour,
        decorationThickness:
            fontFamily != null && fontFamily.isEmpty ? 1.3.spMin : 2.0.spMin,
        letterSpacing: letterSpacing,
      ),
    );
  }

  Text txt10({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 10.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt12({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 12.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt14({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 14.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt15({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 15.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt16({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 16.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt17({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 17.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt18({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 18.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt20({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 20.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }

  Text txt24({
    Color? color,
    Color? decorationColour,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool isHeader = false,
    double? letterSpacing,
    Color? decorationColor,
  }) {
    return txt(
        size: 24.spMin,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColour: decorationColour,
        textAlign: textAlign,
        maxLines: maxLines,
        height: height,
        isHeader: isHeader,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor);
  }
}

extension WidgetExtensionss on num {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );

  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

extension WidgetExtensions on double {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );

  EdgeInsetsGeometry get padA => EdgeInsets.all(this);

  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

extension StringCasingExtension on String {
  String? camelCase() => toBeginningOfSentenceCase(this);
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String? trimToken() => contains(":") ? split(":")[1].trim() : this;
  String? trimSpaces() => replaceAll(" ", "");
  String removeSpacesAndLower() => replaceAll(' ', '').toLowerCase();
}

/// Extension for creating a ValueNotifier from a value directly.
extension NotifierX<T> on T {
  ValueNotifier<T> get notifier {
    return ValueNotifier<T>(this);
  }
}

/// extension for listening to ValueNotifier instances.
extension NotifierBuilderX<T> on ValueNotifier<T> {
  Widget sync({
    required Widget Function(BuildContext context, T value, Widget? child)
        builder,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: builder,
    );
  }
}

extension MultiListenableX on List<Listenable> {
  Widget multiSync({
    required Widget Function(BuildContext context, Widget? child) builder,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge(this),
      builder: builder,
    );
  }
}

extension KycVerificationStatusExtension on KycVerificationStatus {
  bool get isVerified => this == KycVerificationStatus.approved;

  bool get canBeUpdated =>
      this == KycVerificationStatus.pending ||
      this == KycVerificationStatus.declined;
}

extension KycVerificationStatusExtensionNullable on KycVerificationStatus? {
  bool get isVerified => this == KycVerificationStatus.approved;


  bool get canBeUpdated =>
      this == KycVerificationStatus.pending ||
      this == KycVerificationStatus.declined;
}