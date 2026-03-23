import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/line.dart';

// Provider to manage show all state
final showAllCulinarySpecialtiesProvider = StateProvider<bool>((ref) => false);

class CulinarySpecialtiesWidget extends ConsumerWidget {
  const CulinarySpecialtiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(chefController);
    final showAll = ref.watch(showAllCulinarySpecialtiesProvider);
    final showAllNotifier =
        ref.read(showAllCulinarySpecialtiesProvider.notifier);

    // Get culinary specialties from the chef profile
    final backendSpecialties = profileState.profile?.culinarySpecialties ?? [];

    // Handle empty state
    if (backendSpecialties.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Culinary Specialties".txt14(
            fontWeight: FontWeight.w500,  
            color: AppColors.black,
          ),
          12.sbH,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 48,
                  color: AppColors.grey61,
                ),
                const Gap(12),
                "No Specialties selected".txt12(
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyD6,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Process for display
    final displayedSpecialties =
        showAll ? backendSpecialties : backendSpecialties.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Culinary Specialties".txt14(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        12.sbH,
        ...displayedSpecialties.map(_buildSpecialtyItem),
        7.sbH,
        if (backendSpecialties.length > 6)
          AppBtn.from(
            text: showAll ? "Show less specialties" : 'Show all specialties',
            expand: true,
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            bgColor: AppColors.greyF7,
            borderRadius: 8,
            padding: const EdgeInsets.symmetric(vertical: 18),
            border: const BorderSide(color: AppColors.greyF4),
            onPressed: () => showAllNotifier.state = !showAll,
          ),
        12.sbH,
        const HorizontalLine(color: AppColors.greyF7),
        12.sbH,
      ],
    );
  }

  Widget _buildSpecialtyItem(String specialty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          specialty.txt16(
            fontWeight: FontWeight.w500,
            color: AppColors.grey61,
          ),
        ],
      ),
    );
  }
}
