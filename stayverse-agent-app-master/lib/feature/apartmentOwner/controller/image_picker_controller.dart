import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/image_picker_ui_state.dart';

import 'apartment_advert_notifier.dart';

final createApartmentImagePicker =
    StateNotifierProvider<ImagePickerNotifier, List<ImageFile>>((ref) {
  return ImagePickerNotifier(ref, ProviderMode.create);
});

final editApartmentImagePicker =
    StateNotifierProvider<ImagePickerNotifier, List<ImageFile>>((ref) {
  return ImagePickerNotifier(ref, ProviderMode.edit);
});

final createImageSelectionValid = Provider<bool>((ref) {
  final images = ref.watch(createApartmentImagePicker);
  return images.length >= 2 && images.length <= 12;
});

final editImageSelectionValid = Provider<bool>((ref) {
  final images = ref.watch(editApartmentImagePicker);
  return images.length >= 2 && images.length <= 12;
});

class ImagePickerNotifier extends StateNotifier<List<ImageFile>> {
  ImagePickerNotifier(this.ref, this.mode) : super([]);

  final Ref ref;
  final ProviderMode mode;

  static const int minImages = 2;
  static const int maxImages = 12;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      if (state.length >= maxImages) return;

      final remainingSlots = maxImages - state.length;

      // Pick multiple images from gallery
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

        // Update apartment advert state (unchanged)
        final apartmentAdvert = mode == ProviderMode.create
            ? createApartmentAdvert
            : editApartmentAdvert;

        ref.read(apartmentAdvert.notifier).updateApartmentImages(updatedImages);
      }
    } catch (e) {
      BrimToast.showError('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    final updatedImages = List<ImageFile>.from(state)..removeAt(index);
    state = updatedImages;

    // Update apartment advert state
    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    ref.read(apartmentAdvert.notifier).updateApartmentImages(updatedImages);
  }

  void setApartmentImages(List<ImageFile> images) {
    final limitedImages = images.take(maxImages).toList();
    state = limitedImages;

    // Also update the apartment advert state
    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    ref.read(apartmentAdvert.notifier).updateApartmentImages(limitedImages);
  }

  bool get isValid => state.length >= minImages && state.length <= maxImages;

  // Helper to check if we're at max capacity
  bool get isAtMaximum => state.length >= maxImages;
}

// pickImageProvider for cover and photo image picking

final createPickImageProvider =
    StateNotifierProvider<PickImageNotifier, Map<String, ImageFile?>>(
  (ref) => PickImageNotifier(mode: ProviderMode.create, ref: ref),
);

final editPickImageProvider =
    StateNotifierProvider<PickImageNotifier, Map<String, ImageFile?>>(
  (ref) => PickImageNotifier(mode: ProviderMode.edit, ref: ref),
);

class PickImageNotifier extends StateNotifier<Map<String, ImageFile?>> {
  final ProviderMode mode;
  final Ref ref;
  PickImageNotifier({required this.mode, required this.ref})
      : super({"profile": null, "cover": null, "featured": null});

  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfilePicture() async {
    await _pickSingleImage("profile");
  }

  Future<void> pickCoverPhoto() async {
    await _pickSingleImage("cover");
  }

  Future<void> pickFeaturedImage() async {
    await _pickSingleImage("featured");
  }

  Future<void> _pickSingleImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final file = File(image.path);
        final bytes = await file.length();
        if (bytes <= 5 * 1024 * 1024) {
          state = {
            ...state,
            type: ImageFile(
              path: image.path,
              size: bytes,
              name: image.name,
            ),
          };
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(String type) {
    final newState = Map<String, ImageFile?>.from(state);
    newState[type] = null;
    state = newState;
  }

  // Add this method to reset all images
  void resetAllImages() {
    state = {"profile": null, "cover": null, "featured": null};
  }


 // For edit mode only
   void setInitialRemoteImage(String type, String? url) {
    if (url == null || url.isEmpty) return;
    if (mode != ProviderMode.edit) return; // only edit mode loads

    // Prevent overriding if already loaded
    if (state[type] != null) return;

    state = {
      ...state,
      type: ImageFile(
        path: url,
        size: 0,
        name: "remote_$type",
        isRemote: true,
      ),
    };
  }
}
