import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/view/component/confetti_data.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';


class VerificationPage extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onShare;

  const VerificationPage({
    super.key,
    required this.onContinue,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: AppColors.black,
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          // Confetti
          ...generateConfettiPieces(),
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
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 213,
                              width: 213,
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppAsset.chef),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 15,
                              child: SvgPicture.asset(
                                AppAsset.verified,
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ],
                        ),

                        50.sbH,
                        // Message
                        'Congratulation You’re now a verified chef on Stayverse'
                            .txt20(
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
                  child: Column(
                    children: [
                      AppBtn.from(
                        text: 'Share',
                        expand: true,
                        bgColor: Colors.transparent,
                        border: const BorderSide(color: AppColors.white),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        onPressed: onShare,
                      ),
                      9.sbH,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: AppBtn.from(
                          text: 'Continue',
                          expand: true,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                          onPressed: onContinue,
                        ),
                      ),
                    ],
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
