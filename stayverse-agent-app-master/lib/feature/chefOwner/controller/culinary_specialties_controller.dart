import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/feature/chefOwner/view/ui_state/culinary_specialties_ui_state.dart';

final culinarySpecialtiesRepositoryProvider =
    Provider.family<CulinarySpecialtiesRepository, ProviderMode>((ref, mode) {
  return CulinarySpecialtiesRepositoryImpl();
});

final createCulinarySpecialtiesProvider =
    StateNotifierProvider<CulinarySpecialtiesNotifier, List<CulinarySpecialty>>(
        (ref) {
  final repo =
      ref.watch(culinarySpecialtiesRepositoryProvider(ProviderMode.create));
  return CulinarySpecialtiesNotifier(repo, ref, ProviderMode.create);
});

final editCulinarySpecialtiesProvider =
    StateNotifierProvider<CulinarySpecialtiesNotifier, List<CulinarySpecialty>>(
        (ref) {
  final repo =
      ref.watch(culinarySpecialtiesRepositoryProvider(ProviderMode.edit));
  return CulinarySpecialtiesNotifier(repo, ref, ProviderMode.edit);
});

final createCulinarySpecialtyValidProvider = Provider<bool>((ref) {
  final selectedSpecialties = ref
      .watch(createCulinarySpecialtiesProvider)
      .where((specialty) => specialty.isSelected)
      .toList();
  final count = selectedSpecialties.length;
  return count >= 3 && count <= 7;
});

final editCulinarySpecialtyValidProvider = Provider<bool>((ref) {
  final selectedSpecialties = ref
      .watch(editCulinarySpecialtiesProvider)
      .where((specialty) => specialty.isSelected)
      .toList();
  final count = selectedSpecialties.length;
  return count >= 3 && count <= 7;
});

class CulinarySpecialtiesNotifier
    extends StateNotifier<List<CulinarySpecialty>> {
  final CulinarySpecialtiesRepository _repository;
  final Ref ref;
  final ProviderMode mode;

  static const int minSpecialties = 3;
  static const int maxSpecialties = 7;

  CulinarySpecialtiesNotifier(this._repository, this.ref, this.mode)
      : super(_repository.getSpecialties());

  void reset() {
    _repository.resetSpecialties();
    final updatedSpecialties = _repository.getSpecialties();
    state = updatedSpecialties;
  }

  void toggleSpecialty(String name) {
    final currentSpecialty =
        state.firstWhere((specialty) => specialty.name == name);
    final currentSelectedCount =
        state.where((specialty) => specialty.isSelected).length;

    // If trying to select and we're at maximum, don't allow
    if (!currentSpecialty.isSelected &&
        currentSelectedCount >= maxSpecialties) {
      return;
    }

    _repository.toggleSpecialty(name);
    final updatedSpecialties = [..._repository.getSpecialties()];
    state = updatedSpecialties;

    updatedSpecialties
        .where((specialty) => specialty.isSelected)
        .map((specialty) => specialty.name)
        .toList();
  }

  void setSelectedSpecialties(List<String> previous) {
    final updated = _repository.getSpecialties().map((s) {
      return s.copyWith(isSelected: previous.contains(s.name));
    }).toList();

    _repository.setSpecialties(updated);
    state = updated;
  }

  int get selectedCount =>
      state.where((specialty) => specialty.isSelected).length;
}
