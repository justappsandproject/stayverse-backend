import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/event/brim_resgister.dart';
import 'package:stayvers_agent/core/event/evenList/route_history_event.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/splashScreen/view/component/privacy_and_policy_sheet.dart';
import 'package:stayvers_agent/feature/splashScreen/view/component/terms_and_conditions_sheet.dart';
import 'package:stayvers_agent/shared/buttons.dart';

import '../../../../auth/view/page/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  static const route = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: AppAsset.shortlet,
      title: 'Easily list and manage your \nproperties.',
    ),
    OnboardingContent(
      image: AppAsset.chef,
      title: 'Connect with guests who \nneed professional chefs.',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              itemCount: _contents.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        _contents[index].image,
                        fit: BoxFit.cover,
                      ).animate().fade(duration: 600.ms).scale(
                          duration: 800.ms,
                          begin: const Offset(1.1, 1.1),
                          end: const Offset(1, 1)),
                    ),
                    const WhiteGradient(),
                    const WhiteGradient(),
                    const WhiteGradient(),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            height: 0.4.sh,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _contents.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 5,
                    dotWidth: 12,
                    spacing: 8,
                    expansionFactor: 2,
                    dotColor: Colors.grey.withValues(alpha: 0.3),
                    activeDotColor: Colors.amber,
                  ),
                ).animate().fade(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 12),
                Text(
                  _contents[_currentPage].title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 25),
                AppBtn.from(
                  text: _currentPage < _contents.length - 1
                      ? 'Next'
                      : 'Get Started',
                  expand: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                  bgColor: AppColors.black,
                  onPressed: () {
                    if (_currentPage < _contents.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      eventOn<RouteHistoryEvent>(
                          params: {Env.screenStorageScreen: LoginPage.route});
                      $navigate.to(LoginPage.route);
                    }
                  },
                ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 40),
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms &\nConditions',
                        style: TextStyle(
                          color: context.color.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => showTermsAndConditions(context),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: context.color.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => showPrivacyPolicy(context),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ).animate().fade(duration: 500.ms),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WhiteGradient extends StatelessWidget {
  const WhiteGradient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.5),
              Colors.white.withValues(alpha: 0.8),
              Colors.white,
            ],
            stops: const [
              0.3,
              0.5,
              0.7,
              0.85,
              1.0
            ], // Adjusted stops for stronger gradient at the bottom
          ),
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;

  OnboardingContent({
    required this.image,
    required this.title,
  });
}
