import 'package:flutter_animate/flutter_animate.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';

class CustomizedLoadingOverlay {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    String message = 'Processing Secure Payment',
    String description =
        'Your transaction is protected with end-to-end encryption',
    Color backgroundColor = Colors.black54,
    Color? primaryColor,
    Color textColor = Colors.black87,
    Duration enterDuration = const Duration(milliseconds: 400),
    Duration exitDuration = const Duration(milliseconds: 300),
  }) {
    if (_currentOverlay != null) {
      return;
    }

    final brandColor = primaryColor ?? context.color.primary;

    _currentOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          color: backgroundColor,
          child: Center(
            child: Animate(
              effects: [
                ScaleEffect(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: enterDuration,
                  curve: Curves.easeOutBack,
                ),
                FadeEffect(
                  duration: enterDuration * 0.7,
                  curve: Curves.easeOut,
                ),
              ],
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Animate(
                      effects: [
                        FadeEffect(
                          delay: enterDuration * 0.3,
                          duration: enterDuration * 0.5,
                        ),
                      ],
                      child: Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: brandColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          AppAsset.pngLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Animate(
                      effects: [
                        FadeEffect(
                          delay: enterDuration * 0.5,
                          duration: enterDuration * 0.5,
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: brandColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: brandColor.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(brandColor),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Processing message with slide effect
                    Animate(
                      effects: [
                        SlideEffect(
                          delay: enterDuration * 0.6,
                          duration: enterDuration * 0.4,
                          begin: const Offset(0, 0.2),
                          end: const Offset(0, 0),
                        ),
                        FadeEffect(
                          delay: enterDuration * 0.6,
                          duration: enterDuration * 0.4,
                        ),
                      ],
                      child: Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Security reassurance message with delayed entry
                    Animate(
                      effects: [
                        SlideEffect(
                          delay: enterDuration * 0.7,
                          duration: enterDuration * 0.4,
                          begin: const Offset(0, 0.2),
                          end: const Offset(0, 0),
                        ),
                        FadeEffect(
                          delay: enterDuration * 0.7,
                          duration: enterDuration * 0.4,
                        ),
                      ],
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ).animate(),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  // Hide the currently displayed overlay with exit animation
  static void hide() {
    if (_currentOverlay == null) {
      return;
    }
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
