import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/view/page/signup_page.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class SignupAsPage extends ConsumerWidget {
  static const route = '/SignUpAsPage';
  const SignupAsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final baseWidth = isTablet ? 600.0 : screenWidth;

    return BrimSkeleton(
      backgroundColor: AppColors.black,
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              child: SvgPicture.asset(
                AppAsset.pattern,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.12),
                  child: RepaintBoundary(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.025,
                              right: baseWidth * 0.16,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildBubble(
                                      AppAsset.ellipse15, baseWidth * 0.2)
                                  .animate()
                                  .fade(duration: 500.ms)
                                  .slideY(
                                      begin: -0.3,
                                      end: 0,
                                      curve: Curves.easeOut),
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: -baseWidth * 0.1,
                                child: _buildBubble(
                                        AppAsset.ellipse13, baseWidth * 0.25)
                                    .animate()
                                    .fade(duration: 600.ms)
                                    .scale(
                                        delay: 300.ms, curve: Curves.easeOut),
                              ),
                              Positioned(
                                right: -baseWidth * 0.1,
                                child: _buildBubble(
                                        AppAsset.ellipse12, baseWidth * 0.25)
                                    .animate()
                                    .fade(duration: 600.ms)
                                    .scale(
                                        delay: 400.ms, curve: Curves.easeOut),
                              ),
                              _buildBubble(AppAsset.ellipse11, baseWidth * 0.46)
                                  .animate()
                                  .fade(duration: 700.ms)
                                  .scale(delay: 500.ms, curve: Curves.easeOut),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.025,
                              left: baseWidth * 0.2,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _buildBubble(
                                      AppAsset.ellipse14, baseWidth * 0.16)
                                  .animate()
                                  .fade(duration: 500.ms)
                                  .slideY(
                                      begin: 0.3,
                                      end: 0,
                                      curve: Curves.easeOut),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.13),

                          // Animated buttons
                          _buildButton(
                            text: 'Sign up as Chef',
                            bgColor: AppColors.primaryyellow,
                            textColor: Colors.black,
                            context: context,
                            onPressed: () {
                              $navigate.toWithParameters(SignUpPage.route,
                                  args: ServiceType.chef);
                            },
                          ).animate().fade(duration: 500.ms).slideY(
                              begin: 0.5, end: 0, curve: Curves.easeOut),

                          10.sbH,
                          _buildButton(
                            text: 'Sign up as Apartment Owner',
                            bgColor: AppColors.white,
                            textColor: Colors.black,
                            context: context,
                            onPressed: () {
                              $navigate.toWithParameters(SignUpPage.route,
                                  args: ServiceType.apartmentOwner);
                            },
                          ).animate().fade(duration: 500.ms).slideY(
                              begin: 0.5,
                              end: 0,
                              delay: 200.ms,
                              curve: Curves.easeOut),

                          10.sbH,
                          _buildButton(
                            text: 'Sign up as Car Owner',
                            bgColor: Colors.black,
                            textColor: AppColors.white,
                            context: context,
                            onPressed: () {
                              $navigate.toWithParameters(SignUpPage.route,
                                  args: ServiceType.carOwner);
                            },
                          ).animate().fade(duration: 500.ms).slideY(
                              begin: 0.5,
                              end: 0,
                              delay: 400.ms,
                              curve: Curves.easeOut),
                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(String asset, double size, [Widget? child]) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: AppColors.greyD9),
        shape: BoxShape.circle,
        color: AppColors.white,
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }

  Widget _buildButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06),
      child: AppBtn.from(
        text: text,
        expand: true,
        textStyle: $styles.text.bodySmall.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        bgColor: bgColor,
        onPressed: onPressed,
      ),
    );
  }
}
