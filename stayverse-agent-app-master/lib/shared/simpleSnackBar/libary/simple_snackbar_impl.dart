//allow you access all snackbar feature
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/shared/simpleSnackBar/libary/simple_snackbar_controllers.dart';
import 'package:stayvers_agent/shared/simpleSnackBar/libary/simple_snackbar_view.dart';
import 'package:stayvers_agent/shared/simpleSnackBar/libary/util/util.dart';

abstract class SimpleSnackBarInterface {}

class _SimpleSnackBarImpl extends SimpleSnackBarInterface {}

// ignore: non_constant_identifier_names
final SimpleSnackBar = _SimpleSnackBarImpl();

/// give access to Theme.of(context).iconTheme.color
Color? get iconColor => $styles.colors.light.primaryAccent;

extension ExtensionSnackbar on SimpleSnackBarInterface {
  SnackbarController showSnackbar(SimpleSnackBarView snackbar) {
    final controller = SnackbarController(snackbar);
    controller.show();
    return controller;
  }

  SnackbarController snackbar(
    String title,
    String message, {
    Color? colorText,
    Duration? duration = const Duration(seconds: 3),

    /// with instantInit = false you can put snackbar on initState
    bool instantInit = true,
    SnackPosition? snackPosition,
    Widget? titleText,
    Widget? messageText,
    Widget? icon,
    bool? shouldIconPulse,
    double? maxWidth,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    TextButton? mainButton,
    OnTap? onTap,
    bool? isDismissible,
    bool? showProgressIndicator,
    DismissDirection? dismissDirection,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    SnackStyle? snackStyle,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? barBlur,
    double? overlayBlur,
    SnackbarStatusCallback? snackbarStatus,
    Color? overlayColor,
    Form? userInputForm,
  }) {
    final getSnackBar = SimpleSnackBarView(
        snackbarStatus: snackbarStatus,
        titleText: titleText ??
            Text(
              title,
              style: TextStyle(
                color: colorText ?? iconColor ?? Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
        messageText: messageText ??
            Text(
              message,
              style: TextStyle(
                color: colorText ?? iconColor ?? Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
        snackPosition: snackPosition ?? SnackPosition.TOP,
        borderRadius: borderRadius ?? 15,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 10),
        duration: duration,
        barBlur: barBlur ?? 7.0,
        backgroundColor: backgroundColor ?? Colors.grey.withValues(alpha: 0.2),
        icon: icon,
        shouldIconPulse: shouldIconPulse ?? true,
        maxWidth: maxWidth,
        padding: padding ?? const EdgeInsets.all(16),
        borderColor: borderColor,
        borderWidth: borderWidth,
        leftBarIndicatorColor: leftBarIndicatorColor,
        boxShadows: boxShadows,
        backgroundGradient: backgroundGradient,
        mainButton: mainButton,
        onTap: onTap,
        isDismissible: isDismissible ?? true,
        dismissDirection: dismissDirection,
        showProgressIndicator: showProgressIndicator ?? false,
        progressIndicatorController: progressIndicatorController,
        progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
        progressIndicatorValueColor: progressIndicatorValueColor,
        snackStyle: snackStyle ?? SnackStyle.FLOATING,
        forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
        reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
        animationDuration: animationDuration ?? const Duration(seconds: 1),
        overlayBlur: overlayBlur ?? 0.0,
        overlayColor: overlayColor ?? Colors.transparent,
        userInputForm: userInputForm);

    final controller = SnackbarController(getSnackBar);

    if (instantInit) {
      controller.show();
    } else {
      //routing.isSnackbar = true;
      ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((_) {
        controller.show();
      });
    }
    return controller;
  }
}

extension CustomSnackBarKey on SimpleSnackBarInterface {
  
  GlobalKey<NavigatorState> get key => $appKey;

  /// give access to current Overlay Context
  BuildContext? get overlayContext {
    BuildContext? overlay;
    key.currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }
}
