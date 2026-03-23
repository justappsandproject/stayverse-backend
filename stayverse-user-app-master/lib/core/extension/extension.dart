import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/color/color_styles.dart';

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

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension IterableExtension<T> on Iterable<T> {
  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the [compare] [Comparator].
  List<T> sorted(Comparator<T> compare) => [...this]..sort(compare);
}

extension ImageExtension on num {  
  int cacheSize(BuildContext context) {  
    return (this * MediaQuery.of(context).devicePixelRatio).round();  
  }  
}