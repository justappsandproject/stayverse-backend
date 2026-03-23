import 'package:confetti/confetti.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'confetti_data.dart';

class ConfirmationPage extends StatefulWidget {
  static const route = '/ConfirmationPage';
  final String message;
  final String buttonText;
  final VoidCallback onContinue;
  final bool? underApproval;

  const ConfirmationPage({
    super.key,
    this.message =
        'Your Post is under review,\nwe\'ll let you know when it goes live',
    this.buttonText = 'Continue',
    required this.onContinue,
    this.underApproval = false,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: AppColors.black,
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          // Confetti
          ConfettiWidget(
            emissionFrequency: 0.05,
            confettiController: _controller,
            numberOfParticles: 20,
            pauseEmissionOnLowFrameRate: true,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ],
          ),
          // ...generateConfettiPieces(),
          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                // Centered Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rocket
                        SvgPicture.asset(
                          height: 138,
                          width: 138,
                          AppAsset.rocket,
                        ),
                        50.sbH,
                        // Message
                        widget.underApproval == true
                            ? widget.message.txt16(
                                fontFamily: Constant.sora,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                                textAlign: TextAlign.center,
                              )
                            : widget.message.txt(
                                size: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                                textAlign: TextAlign.center,
                              ),
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: AppBtn.from(
                      text: widget.buttonText,
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      onPressed: widget.onContinue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateConfettiPieces() {
    final confettiData = [
      ConfettiData(
        left: 14,
        top: 62,
        color: AppColors.pinkAA,
        rotation: 105,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        left: 152,
        top: 113,
        color: AppColors.blueC7,
        rotation: -30,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        left: 237,
        top: 183,
        color: AppColors.creamDA,
        rotation: -30,
        shape: ConfettiShape.circle,
        size: const Size(4, 4),
      ),
      // Circular confetti
      ConfettiData(
        left: 40,
        top: 215,
        color: AppColors.purpleCF,
        rotation: 150,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(16, 8),
      ),
      ConfettiData(
        left: 154,
        top: 296,
        color: AppColors.purpleEA,
        rotation: -120,
        shape: ConfettiShape.rectangle,
        hasRadius: false,
        size: const Size(4, 4),
      ),
      // Mix of both shapes
      ConfettiData(
        right: 63,
        top: 296,
        color: AppColors.blueBF,
        rotation: -105,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(8, 8),
      ),
      ConfettiData(
        right: 3,
        top: 255,
        color: AppColors.pinkAA,
        rotation: -60,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(16, 8),
      ),
      ConfettiData(
        left: 13,
        top: 354,
        color: AppColors.blueBF,
        rotation: -30,
        shape: ConfettiShape.circle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        left: 2,
        top: 482,
        color: AppColors.pinkAA,
        rotation: -105,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        left: 122,
        top: 482,
        color: AppColors.pinkAA,
        rotation: -30,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        right: 6,
        top: 426,
        color: AppColors.purpleCF,
        rotation: -30,
        shape: ConfettiShape.circle,
        size: const Size(7, 7),
      ),
      ConfettiData(
        right: -2,
        top: 463,
        color: AppColors.creamDA,
        rotation: -30,
        shape: ConfettiShape.circle,
        size: const Size(4, 4),
      ),
      ConfettiData(
        right: 98,
        top: 497,
        color: AppColors.purpleCF,
        rotation: -30,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        left: 152,
        top: 533,
        color: AppColors.blueC7,
        rotation: -30,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
      ConfettiData(
        right: 151,
        top: 602,
        color: AppColors.creamDA,
        rotation: -30,
        shape: ConfettiShape.rectangle,
        size: const Size(4, 4),
      ),
      ConfettiData(
        left: 40,
        top: 634,
        color: AppColors.purpleEA,
        rotation: -150,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(16, 8),
      ),

      ConfettiData(
        left: 154,
        bottom: 132,
        color: AppColors.purpleCF,
        rotation: -120,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(4, 4),
      ),
      ConfettiData(
        right: 3,
        bottom: 154,
        color: AppColors.pinkAA,
        rotation: -60,
        hasRadius: false,
        shape: ConfettiShape.rectangle,
        size: const Size(16, 8),
      ),
      ConfettiData(
        right: 120,
        bottom: 2,
        color: AppColors.purpleCF,
        rotation: -30,
        shape: ConfettiShape.rectangle,
        size: const Size(11, 11),
      ),
    ];

    return confettiData.map((data) {
      return Positioned(
        left: data.left,
        right: data.right,
        top: data.top,
        bottom: data.bottom,
        child: Transform.rotate(
          angle: data.rotation * (3.14159 / 180),
          child: CustomPaint(
            painter: ConfettiPainter(
              color: data.color,
              shape: data.shape,
              hasRadius: data.hasRadius,
            ),
            size: data.size,
          ),
        ),
      );
    }).toList();
  }
}
