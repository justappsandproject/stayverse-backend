import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';

import '../../apartmentOwner/view/ui_state/image_picker_ui_state.dart';
import 'ride_advert_controller.dart';

final createRideImagePickerProvider =
    StateNotifierProvider<RideImagePickerNotifier, List<ImageFile>>((ref) {
  return RideImagePickerNotifier(ref, ProviderMode.create);
});

final editRideImagePickerProvider =
    StateNotifierProvider<RideImagePickerNotifier, List<ImageFile>>((ref) {
  return RideImagePickerNotifier(ref, ProviderMode.edit);
});

final createImageSelectionValidProvider = Provider<bool>((ref) {
  final images = ref.watch(createRideImagePickerProvider);
  return images.length >= 2 && images.length <= 12;
});

final editImageSelectionValidProvider = Provider<bool>((ref) {
  final images = ref.watch(editRideImagePickerProvider);
  return images.length >= 2 && images.length <= 12;
});

class RideImagePickerNotifier extends StateNotifier<List<ImageFile>> {
  RideImagePickerNotifier(this.ref, this.mode) : super([]);

  final Ref ref;
  final ProviderMode mode;

  static const int minImages = 2;
  static const int maxImages = 12;

    final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      if (state.length >= maxImages) return;

      final remainingSlots = maxImages - state.length;

      // ✅ Pick multiple images from gallery
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        final List<ImageFile> validImages = pickedFiles
            .where((file) {
              final ext = file.name.split('.').last.toLowerCase();
              final validExt = ['jpg', 'png', 'jpeg', 'gif'];
              return validExt.contains(ext);
            })
            .where((file) {
              final size = File(file.path).lengthSync();
              return size <= 5 * 1024 * 1024; // 5MB limit
            })
            .take(remainingSlots)
            .map((file) {
              final size = File(file.path).lengthSync();
              return ImageFile(
                path: file.path,
                size: size,
                name: file.name,
              );
            })
            .toList();

        final updatedImages = [...state, ...validImages];
        state = updatedImages;

        // ✅ Update ride advert state
        final advertProvider = mode == ProviderMode.create
            ? createRideAdvertProvider
            : editRideAdvertProvider;

        ref.read(advertProvider.notifier).updateRideImages(updatedImages);
      }
    } catch (e) {
     BrimToast.showError('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    final updatedrideImages = List<ImageFile>.from(state)..removeAt(index);
    state = updatedrideImages;

    // Update apartment advert state
    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    ref.read(advertProvider.notifier).updateRideImages(updatedrideImages);
  }

  void setRideImages(List<ImageFile> images) {
    final limitedImages = images.take(maxImages).toList();
    state = limitedImages;

    // Also update the apartment advert state
    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    ref.read(advertProvider.notifier).updateRideImages(limitedImages);
  }

  bool get isValid => state.length >= minImages && state.length <= maxImages;

  // Helper to check if we're at max capacity
  bool get isAtMaximum => state.length >= maxImages;
}
