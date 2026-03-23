import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/full_screen_dailog.dart';
import 'package:stayverse/shared/selfieCamera/component/header.dart';
import 'package:stayverse/shared/selfieCamera/component/instrunction.dart';
import 'package:stayverse/shared/selfieCamera/component/powered_by_flex.dart';
import 'package:stayverse/shared/selfieCamera/component/selfieView/face_processor.dart';
import 'package:stayverse/shared/skeleton.dart';

class SelfieDialog extends ConsumerStatefulWidget {
  final Function(File) onSelfie;
  const SelfieDialog({
    super.key,
    required this.onSelfie,
  });

  @override
  ConsumerState<SelfieDialog> createState() => _SelfieDialogState();

  static void show(BuildContext context, Function(File) onSelfie) {
    showFullScreenDialog(context, child: SelfieDialog(onSelfie: onSelfie));
  }
}

class _SelfieDialogState extends ConsumerState<SelfieDialog> {
  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      bodyPadding: const EdgeInsets.all(16),
      backgroundColor: $styles.colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(0.05.sh),
              const SelfieHeader(),
              const Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaceDetectorProcessor(
                      onSelfie: (File value) {
                        $navigate.back();
                        widget.onSelfie(value);
                      },
                    ),
                    const Gap(20),
                    const SelfieInstruction(),
                    const Gap(20),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: const PoweredByStayvers()),
              ],
            ),
          )
        ],
      ),
      isBusy: false,
    );
  }
}
