import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/culinary_specialties_controller.dart';

class CulinarySpecialtiesSelection extends ConsumerWidget {
  final ProviderMode mode;
  const CulinarySpecialtiesSelection({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final culinarySpecialtiesProvider = mode == ProviderMode.create
        ? createCulinarySpecialtiesProvider
        : editCulinarySpecialtiesProvider;
    final specialties = ref.watch(culinarySpecialtiesProvider);
    final selectedSpecialties = specialties.where((s) => s.isSelected).toList();
    final selectedCount = selectedSpecialties.length;
    final isValid = selectedCount >= 3 && selectedCount <= 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Culinary Specialties'.txt14(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        Gap(10.spaceScale),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.greyD6),
          ),
          constraints: const BoxConstraints(minHeight: 100),
          child: selectedSpecialties.isEmpty
              ? const Text(
                  'Select 3-7 culinary specialties',
                  style: TextStyle(color: Colors.black38),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedSpecialties.map((specialty) {
                    return ActionChip(
                      label: Text(
                        specialty.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryyellow,
                        ),
                      ),
                      side: const BorderSide(
                        color: AppColors.yellowC9,
                      ),
                      backgroundColor: AppColors.yellowD7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () => ref
                          .read(culinarySpecialtiesProvider.notifier)
                          .toggleSpecialty(specialty.name),
                    );
                  }).toList(),
                ),
        ),
        if (!isValid)
          const Text(
            '**minimum of 3 Specialty required**',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        13.sbH,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: specialties
              .where((specialty) => !specialty.isSelected)
              .map((specialty) {
            final atMaxSelection = selectedSpecialties.length >= 7;
            return ActionChip(
              label: Text(
                specialty.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: atMaxSelection ? Colors.grey : AppColors.black,
                ),
              ),
              side: BorderSide(
                color: atMaxSelection ? Colors.grey.shade300 : AppColors.greyF4,
              ),
              backgroundColor:
                  atMaxSelection ? Colors.grey.shade100 : AppColors.greyF7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: atMaxSelection
                  ? null
                  : () => ref
                      .read(culinarySpecialtiesProvider.notifier)
                      .toggleSpecialty(specialty.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
