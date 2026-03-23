
// ignore_for_file: deprecated_member_use

// Define a consistent enum for toast types
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/simpleSnackBar/libary/simple_snackbar_impl.dart';

enum ToastType { success, error, hint, info, warning }

class BrimToast {
  // Define constants for consistent styling
  static const double _defaultOpacity = 0.8;

  // Get color based on toast type
  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.teal;
      case ToastType.error:
        return Colors.red;
      case ToastType.hint:
        return Colors.blue;
      case ToastType.info:
        return Colors.teal;
      case ToastType.warning:
        return Colors.orange;
    }
  }

  // Get default title based on toast type
  static String _getDefaultTitle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return 'Success';
      case ToastType.error:
        return 'Error';
      case ToastType.hint:
        return 'Hint';
      case ToastType.info:
        return 'Information';
      case ToastType.warning:
        return 'Warning';
    }
  }

  // Generic show method to reduce code duplication
  static void _show(
    String message, {
    String? title,
    required ToastType type,
    double opacity = _defaultOpacity,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color backgroundColor = _getColor(type).withOpacity(opacity);
    final String finalTitle = title ?? _getDefaultTitle(type);

    SimpleSnackBar.snackbar(
      finalTitle,
      message,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
      duration: duration,
    );
  }

  // Public methods with consistent interfaces
  static void showSuccess(String message, {String? title, Duration? duration}) {
    _show(
      message,
      title: title,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showError(String message, {String? title, Duration? duration}) {
    _show(
      message,
      title: title,
      type: ToastType.error,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void showHint(String message, {String? title, Duration? duration}) {
    _show(
      message,
      title: title,
      type: ToastType.hint,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showInfo(String message, {String? title, Duration? duration}) {
    _show(
      message,
      title: title,
      type: ToastType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showWarning(String message, {String? title, Duration? duration}) {
    _show(
      message,
      title: title,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
