import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/selfieCamera/controller/selfie_controller.dart';


class CameraView extends ConsumerStatefulWidget {
  const CameraView({super.key, required this.onImage});
  final Function(XFile imageFile) onImage; // Changed to XFile

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _cameraIndex = -1;
  final _cameraLensDirection = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == _cameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }

    //If a camera was found
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController?.value.isInitialized != true) {
      return SizedBox(
        height: 0.4.sh,
        width: 0.75.sw,
        child: ClipPath(
          clipper: EllipseClipper(),
          child: ColoredBox(
            color: $styles.colors.black.withValues(alpha: 0.05),
            child:  Center(
              child: CircularProgressIndicator(
                color: $styles.colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 0.4.sh,
            width: 0.75.sw,
            child: ClipPath(
                clipper: EllipseClipper(),
                child: ColoredBox(
                    color: $styles.colors.white.withValues(alpha: 0.05),
                    child: CameraPreview(_cameraController!)))),
        const Gap(10),
        ref.watch(selfieController.select((value) => value.isProcessing))
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(100),
                    valueColor: AlwaysStoppedAnimation(
                        context.themeColors.primaryAccent),
                    backgroundColor: $styles.colors.white,
                  ),
                  const Gap(10),
                  Text(
                    'Processing Selfie',
                    textAlign: TextAlign.center,
                    style: $styles.text.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: $styles.colors.black,
                        fontSize: 14.sp),
                  ),
                ],
              )
            : AppBtn.from(
                expand: false,
                text: 'Take Selfie',
                borderRadius: 10,
                textColor: $styles.colors.black,
                onPressed: _takePicture,
                semanticLabel: '',
              )
      ],
    );
  }

  void _startLiveFeed() async {
    try {
      final camera = _cameras[_cameraIndex];
      _cameraController = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController?.initialize();

      await _cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);

      // Get the zoom range with null safety
      final minZoom = await _cameraController?.getMinZoomLevel() ?? 1.0;
      final maxZoom = await _cameraController?.getMaxZoomLevel() ?? 1.0;

      double targetZoom = 2;

      if (targetZoom >= minZoom &&
          targetZoom <= maxZoom &&
          _cameraController != null) {
        await _cameraController!.setZoomLevel(targetZoom);
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera $e');
    }
  }

  void _takePicture() async {
    try {
      final image = await _cameraController!.takePicture();
      // Directly pass the XFile to the callback
      widget.onImage(image);
    } catch (e) {
      BrimToast.showError('Try Taking Selfie Again');
      debugPrint('Error taking picture: $e');
    }
  }

  Future _stopLiveFeed() async {
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();
    _cameraController = null;
  }
}

class EllipseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Draw an ellipse
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
