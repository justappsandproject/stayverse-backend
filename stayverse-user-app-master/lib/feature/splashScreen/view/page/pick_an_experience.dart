import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/event/brim_resgister.dart';
import 'package:stayverse/core/event/evenList/route_history_event.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class PickAnExperience extends ConsumerStatefulWidget {
  static const route = '/PickAnExperience';
  const PickAnExperience({super.key});

  @override
  ConsumerState<PickAnExperience> createState() => _PickAnExperienceState();
}

class _PickAnExperienceState extends ConsumerState<PickAnExperience> {
  String selected = UserExperiences.user.name;

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: const AppBackButton(),
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 45),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How would you like to experience Stayverse?',
              textAlign: TextAlign.center,
              style: $styles.text.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                color: Colors.black,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(
                  begin: -0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
            const Gap(40),
            ExperienceContainer(
              icon: AppIcons.person,
              title: 'I’m a User',
              description:
                  'Find verified apartments, private chefs, and premium rides — all in one apps.',
              btnText: 'Continue as User',
              isSelected: selected == UserExperiences.user.name,
              onTap: () {
                setState(() => selected = UserExperiences.user.name);
              },
              onBtnPress: () {
                eventOn<RouteHistoryEvent>(
                    params: {Env.screenStorageScreen: LoginPage.route});
                $navigate.to(LoginPage.route);
              },
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
                  begin: -0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
            const Gap(38),
            ExperienceContainer(
              icon: AppIcons.work,
              title: 'I’m a Host',
              description:
                  'List your apartment, car, or kitchen and start earning from verified clients.',
              btnText: 'Continue as Host',
              isSelected: selected == UserExperiences.host.name,
              onTap: () {
                setState(() => selected = UserExperiences.host.name);
              },
              onBtnPress: () {
                launchStore();
              },
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(
                  begin: -0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

class ExperienceContainer extends StatelessWidget {
  final AppIcons icon;
  final String title;
  final String description;
  final String btnText;
  final VoidCallback onBtnPress;
  final VoidCallback onTap;
  final bool isSelected;

  const ExperienceContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.btnText,
    required this.onBtnPress,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8E7) : const Color(0xFFF9F9F9),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFBC036) : const Color(0xFFC4C4C4),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFBC036)
                        : const Color(0xFFD1D1D1),
                  )),
              padding: const EdgeInsets.all(11),
              child: Center(
                child: AppIcon(
                  icon,
                  size: 39,
                  color: isSelected
                      ? const Color(0xFFFBC036)
                      : const Color(0xFFCBCBCB),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(
                  begin: -0.5,
                  end: 0,
                  duration: 300.ms,
                  delay: 100.ms,
                ),
            const Gap(10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: $styles.text.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: isSelected
                    ? const Color(0xFFFBC036)
                    : const Color(0xFFA4A4A4),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(
                  begin: -0.5,
                  end: 0,
                  duration: 300.ms,
                  delay: 150.ms,
                ),
            const Gap(10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: $styles.text.body.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isSelected ? Colors.black : const Color(0xFF5A5957),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(
                  begin: -0.5,
                  end: 0,
                  duration: 300.ms,
                  delay: 200.ms,
                ),
            const Gap(24),
            AppBtn.from(
              text: btnText,
              expand: true,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : const Color(0xFF8C8787),
              ),
              bgColor: isSelected
                  ? const Color(0xFFFBC036)
                  : const Color(0xFFE3E3E2),
              onPressed: onBtnPress,
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(
                  begin: -0.5,
                  end: 0,
                  duration: 300.ms,
                  delay: 250.ms,
                ),
          ],
        ),
      ),
    );
  }
}
