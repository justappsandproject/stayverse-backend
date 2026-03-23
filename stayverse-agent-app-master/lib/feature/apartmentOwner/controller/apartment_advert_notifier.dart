import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/amenity_selection_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/image_picker_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/apartment_advert_state.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/custom_textfield_ui_state.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/time_picker_ui_state.dart';

import '../view/ui_state/image_picker_ui_state.dart';

class ApartmentAdvertNotifier extends StateNotifier<ApartmentAdvertState> {
  final Ref ref;
  final ProviderMode mode;
  bool _isDataLoaded = false;

  ApartmentAdvertNotifier(this.ref, this.mode) : super(ApartmentAdvertState()) {
    // Initialize controllers with existing state values
    _initializeControllers();
  }

  void _initializeControllers() {
    apartmentNameController.text = state.apartmentName ?? '';
    detailsController.text = state.details ?? '';
    locationController.text = state.location ?? '';
    houseRulesController.text = state.houseRules ?? '';
    maxGuestsController.text = state.maxGuests != null && state.maxGuests! > 0
        ? state.maxGuests.toString()
        : '';
    numberOfBathroomsController.text =
        state.numberOfBathrooms != null && state.numberOfBathrooms! > 0
            ? state.numberOfBathrooms.toString()
            : '';
    priceController.text = state.pricePerDay != null && state.pricePerDay! > 0
        ? state.pricePerDay.toString()
        : '';
    cautionFeeController.text =
        state.cautionFee != null && state.cautionFee! > 0
            ? state.cautionFee.toString()
            : '';
    checkInController.text = state.checkIn ?? '';
    checkOutController.text = state.checkOut ?? '';
  }

  // Text controllers for form fields
  final apartmentNameController = TextEditingController();
  final detailsController = TextEditingController();
  final locationController = TextEditingController();
  final houseRulesController = TextEditingController();
  final maxGuestsController = TextEditingController();
  final numberOfBathroomsController = TextEditingController();
  final priceController = TextEditingController();
  final cautionFeeController = TextEditingController();
  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();

  // Focus nodes
  final locationFocusNode = FocusNode();

  // Method to update state from all controllers
  void updateStateFromControllers() {
    state = state.copyWith(
      apartmentName: apartmentNameController.text,
      details: detailsController.text,
      location: locationController.text,
      houseRules: houseRulesController.text,
      maxGuests: maxGuestsController.text.isNotEmpty
          ? int.tryParse(maxGuestsController.text)
          : state.maxGuests,
      numberOfBathrooms: numberOfBathroomsController.text.isNotEmpty
          ? int.tryParse(numberOfBathroomsController.text)
          : state.numberOfBathrooms,
      pricePerDay: priceController.text.isNotEmpty
          ? double.tryParse(
              priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''))
          : state.pricePerDay,
      cautionFee: cautionFeeController.text.isNotEmpty
          ? double.tryParse(
              cautionFeeController.text.replaceAll(RegExp(r'[^0-9.]'), ''))
          : state.cautionFee,
      checkIn: checkInController.text,
      checkOut: checkOutController.text,
    );
  }

  // Non-text fields still update state directly
  void setSelectedPlaceId(String placeId) {
    state = state.copyWith(selectedPlaceId: placeId);
  }

  void updateApartmentType(String type) {
    state = state.copyWith(apartmentType: type);
  }

  void updateApartmentImages(List<ImageFile> images) {
    state = state.copyWith(apartmentImages: images);
  }

  void updateAmenities(List<String> amenities) {
    state = state.copyWith(amenities: amenities);
  }

  // // Clean up resources when done
  // @override
  // void dispose() {
  //   super.dispose();
  //   apartmentNameController.dispose();
  //   detailsController.dispose();
  //   locationController.dispose();
  //   houseRulesController.dispose();
  //   maxGuestsController.dispose();
  //   numberOfBathroomsController.dispose();
  //   priceController.dispose();
  //   checkInController.dispose();
  //   checkOutController.dispose();
  //   locationFocusNode.dispose();
  // }

  void loadApartmentData(Apartment apartment, WidgetRef ref) {
    if (_isDataLoaded) return;

    apartmentNameController.text = apartment.apartmentName ?? '';
    detailsController.text = apartment.details ?? '';
    locationController.text = apartment.address ?? '';
    houseRulesController.text = apartment.houseRules ?? '';
    maxGuestsController.text =
        apartment.maxGuests != null && apartment.maxGuests! > 0
            ? apartment.maxGuests.toString()
            : '';
    numberOfBathroomsController.text =
        apartment.numberOfBedrooms != null && apartment.numberOfBedrooms! > 0
            ? apartment.numberOfBedrooms.toString()
            : '';
    priceController.text =
        apartment.pricePerDay != null && apartment.pricePerDay! > 0
            ? apartment.pricePerDay.toString()
            : '';
    cautionFeeController.text =
        apartment.cautionFee != null && apartment.cautionFee! > 0
            ? apartment.cautionFee.toString()
            : '';
    checkInController.text =
        apartment.checkIn != null ? apartment.checkIn!.toIso8601String() : '';
    checkOutController.text =
        apartment.checkOut != null ? apartment.checkOut!.toIso8601String() : '';

    final imageFiles = (apartment.apartmentImages ?? []).map((url) {
      return ImageFile(
        path: url,
        size: 0,
        name: url.split('/').last,
        isRemote: true,
      );
    }).toList();

    // update state
    state = state.copyWith(
      apartmentName: apartment.apartmentName,
      details: apartment.details,
      location: apartment.address,
      houseRules: apartment.houseRules,
      maxGuests: apartment.maxGuests,
      numberOfBathrooms: apartment.numberOfBedrooms,
      pricePerDay: apartment.pricePerDay?.toDouble(),
      cautionFee: apartment.cautionFee?.toDouble(),
      checkIn: apartment.checkIn.toString(),
      checkOut: apartment.checkOut.toString(),
      apartmentType: _normalizeType(apartment.apartmentType),
      amenities: apartment.amenities ?? [],
      apartmentImages: imageFiles,
    );

    // apartment type
    if (apartment.apartmentType != null) {
      final apartmentTypeProvider =
          mode == ProviderMode.create ? createApartmentType : editApartmentType;
      ref
          .read(apartmentTypeProvider.notifier)
          .selectType(_normalizeType(apartment.apartmentType!)!);
    }

    // amenities
    if (apartment.amenities?.isNotEmpty == true) {
      final amenitiesProvider = mode == ProviderMode.create
          ? createApartmentAmenities
          : editApartmentAmenities;
      ref
          .read(amenitiesProvider.notifier)
          .setSelectedAmenities(apartment.amenities!);
    }

    // images
    if (imageFiles.isNotEmpty) {
      final imagesProvider = mode == ProviderMode.create
          ? createApartmentImagePicker
          : editApartmentImagePicker;
      ref.read(imagesProvider.notifier).setApartmentImages(imageFiles);
    }

    _isDataLoaded = true;
  }

  void resetAllFormData(WidgetRef ref) {
    // Reset all form controllers
    apartmentNameController.clear();
    detailsController.clear();
    locationController.clear();
    houseRulesController.clear();
    maxGuestsController.clear();
    numberOfBathroomsController.clear();
    priceController.clear();
    cautionFeeController.clear();
    checkInController.clear();
    checkOutController.clear();

    // Reset internal advert state (for text fields and derived values)
    state = ApartmentAdvertState(
      apartmentType: '',
      amenities: [],
      apartmentImages: [],
    );

    // Reset individual providers (crucial!)
    final imagesProvider = mode == ProviderMode.create
        ? createApartmentImagePicker
        : editApartmentImagePicker;
    final amenitiesProvider = mode == ProviderMode.create
        ? createApartmentAmenities
        : editApartmentAmenities;
    final apartmentTimePicker = mode == ProviderMode.create
        ? createApartmentTimePicker
        : editApartmentTimePicker;
    final apartmentTypeProvider =
        mode == ProviderMode.create ? createApartmentType : editApartmentType;

    ref.read(imagesProvider.notifier).setApartmentImages([]);
    ref.read(amenitiesProvider.notifier).reset();
    ref.read(apartmentTypeProvider.notifier).reset();
    ref.read(apartmentTimePicker.notifier).setTimes(
          checkIn: null,
          checkOut: null,
        );

    // Optionally reset textFieldProvider entries if needed
    final semanticLabels = ['No. Bathrooms', 'Min. Price', 'No. Guest'];
    for (final label in semanticLabels) {
      ref.read(textFieldProvider(label).notifier).updateText('');
    }
    _isDataLoaded = false;
  }
}

// Provider for managing apartment advert state

final createApartmentAdvert =
    StateNotifierProvider<ApartmentAdvertNotifier, ApartmentAdvertState>((ref) {
  return ApartmentAdvertNotifier(ref, ProviderMode.create);
});

final editApartmentAdvert =
    StateNotifierProvider<ApartmentAdvertNotifier, ApartmentAdvertState>((ref) {
  return ApartmentAdvertNotifier(ref, ProviderMode.edit);
});

String? _normalizeType(String? type) {
  if (type == null) return null;
  switch (type.toLowerCase()) {
    case 'studio':
      return 'Studio';
    case 'one-bedroom':
      return 'One-bedroom';
    case 'two-bedroom':
      return 'Two-bedroom';
    default:
      return type;
  }
}
