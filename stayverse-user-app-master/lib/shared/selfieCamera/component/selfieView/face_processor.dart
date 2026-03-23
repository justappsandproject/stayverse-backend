import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/selfieCamera/component/selfieView/camera_view.dart';
import 'package:stayverse/shared/selfieCamera/controller/selfie_controller.dart';

class FaceDetectorProcessor extends ConsumerStatefulWidget {
  const FaceDetectorProcessor({super.key, required this.onSelfie});
  final ValueChanged<File> onSelfie;

  @override
  ConsumerState<FaceDetectorProcessor> createState() =>
      _FaceDetectorProcessorState();
}

class _FaceDetectorProcessorState extends ConsumerState<FaceDetectorProcessor> {
  @override
  Widget build(BuildContext context) {
    return CameraView(onImage: (xfile) async {
      await ref.read(selfieController.notifier).processImage(xfile);
      widget.onSelfie(File(xfile.path));
    });
  }
}
