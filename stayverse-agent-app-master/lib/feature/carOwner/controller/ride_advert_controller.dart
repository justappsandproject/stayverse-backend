import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/custom_textfield_ui_state.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/image_picker_ui_state.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_amenities_controller.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_image_picker_controller.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/carOwner/view/ui_state/ride_advert_state.dart';

class RideAdvertNotifier extends StateNotifier<RideAdvertState> {
  final Ref ref;
  final ProviderMode mode;
  bool _isDataLoaded = false;

  RideAdvertNotifier(this.ref, this.mode) : super(RideAdvertState()) {
    // Initialize controllers with existing state values
    _initializeControllers();
  }

  void _initializeControllers() {
    rideNameController.text = state.rideName ?? '';
    rideDetailsController.text = state.rideDescription ?? '';
    locationController.text = state.address ?? '';
    ridepriceController.text =
        state.pricePerHour != null && state.pricePerHour! > 0
            ? state.pricePerHour.toString()
            : '';
    cautionFeeController.text =
        state.cautionFee != null && state.cautionFee! > 0
            ? state.cautionFee.toString()
            : '';
    rideRulesController.text = state.rules ?? '';
    numOfPassController.text =
        state.maxPassengers != null && state.maxPassengers! > 0
            ? state.maxPassengers.toString()
            : '';
    rideplateController.text = state.plateNumber ?? '';
    rideIdNumController.text = state.vehicleVerificationNumber ?? '';
    rideRegNoController.text = state.registrationNumber ?? '';
    rideColorController.text = state.color ?? '';
  }

  // Text controllers for form fields
  final rideNameController = TextEditingController();
  final rideDetailsController = TextEditingController();
  final locationController = TextEditingController();
  final ridepriceController = TextEditingController();
  final cautionFeeController = TextEditingController();
  final rideRulesController = TextEditingController();
  final numOfPassController = TextEditingController();
  final rideplateController = TextEditingController();
  final rideIdNumController = TextEditingController();
  final rideRegNoController = TextEditingController();
  final rideColorController = TextEditingController();

  // Focus nodes
  final locationFocusNode = FocusNode();

  void updateStateFromControllers() {
    state = state.copyWith(
      rideName: rideNameController.text,
      rideDescription: rideDetailsController.text,
      address: locationController.text,
      pricePerHour: ridepriceController.text.isNotEmpty
          ? double.tryParse(
              ridepriceController.text.replaceAll(RegExp(r'[^0-9.]'), ''))
          : state.pricePerHour,
      cautionFee: cautionFeeController.text.isNotEmpty
          ? double.tryParse(
              cautionFeeController.text.replaceAll(RegExp(r'[^0-9.]'), ''))
          : state.cautionFee,
      rules: rideRulesController.text,
      maxPassengers: numOfPassController.text.isNotEmpty
          ? int.tryParse(numOfPassController.text)
          : state.maxPassengers,
      plateNumber: rideplateController.text,
      vehicleVerificationNumber: rideIdNumController.text,
      registrationNumber: rideRegNoController.text,
      color: rideColorController.text,
    );
  }

  void updatePlaceId(String placeId) {
    state = state.copyWith(placeId: placeId);
  }

  void updateRideType(String rideType) {
    state = state.copyWith(rideType: rideType);
  }

  void updateFeatures(List<String> features) {
    state = state.copyWith(features: features);
  }

  void updateRideImages(List<ImageFile> images) {
    state = state.copyWith(rideImages: images);
  }

  void loadRideData(Ride ride, WidgetRef ref) {
    if (_isDataLoaded) return;
    // populate controllers
    rideNameController.text = ride.rideName ?? '';
    rideDetailsController.text = ride.rideDescription ?? '';
    locationController.text = ride.address ?? '';
    ridepriceController.text =
        ride.pricePerHour != null ? ride.pricePerHour.toString() : '';
    cautionFeeController.text =
        ride.cautionFee != null ? ride.cautionFee.toString() : '';
    rideRulesController.text = ride.rules ?? '';
    numOfPassController.text =
        ride.maxPassengers != null ? ride.maxPassengers.toString() : '';
    rideplateController.text = ride.plateNumber ?? '';
    rideIdNumController.text = ride.vehicleVerificationNumber ?? '';
    rideRegNoController.text = ride.registrationNumber ?? '';
    rideColorController.text = ride.color ?? '';

    final imageFiles = (ride.rideImages ?? []).map((url) {
      return ImageFile(
        path: url,
        size: 0,
        name: url.split('/').last,
        isRemote: true,
      );
    }).toList();

    // update state
    state = state.copyWith(
      rideName: ride.rideName,
      rideDescription: ride.rideDescription,
      address: ride.address,
      pricePerHour: ride.pricePerHour?.toDouble(),
      cautionFee: ride.cautionFee?.toDouble(),
      rules: ride.rules,
      maxPassengers: ride.maxPassengers,
      plateNumber: ride.plateNumber,
      vehicleVerificationNumber: ride.vehicleVerificationNumber,
      registrationNumber: ride.registrationNumber,
      color: ride.color,
      rideType: _normalizeType(ride.rideType),
      features: ride.features ?? [],
      rideImages: imageFiles,
    );

    // vehicle type
    if (ride.rideType != null) {
      final vehicleTypeProvider = mode == ProviderMode.create
          ? createVehicleType
          : editVehicleType;
      ref.read(vehicleTypeProvider.notifier).selectType(_normalizeType(ride.rideType!)!);
    }

// amenities
    if (ride.features?.isNotEmpty == true) {
      final amenitiesProvider = mode == ProviderMode.create
          ? createRideAmenitiesProvider
          : editRideAmenitiesProvider;
      ref.read(amenitiesProvider.notifier).setSelectedAmenities(ride.features!);
    }

    // images
    if (imageFiles.isNotEmpty) {
      final imagesProvider = mode == ProviderMode.create
          ? createRideImagePickerProvider
          : editRideImagePickerProvider;
      ref.read(imagesProvider.notifier).setRideImages(imageFiles);
    }
    _isDataLoaded = true;
  }

  void resetAllFormData(WidgetRef ref) {
    // Reset all form controllers
    rideNameController.clear();
    rideDetailsController.clear();
    locationController.clear();
    ridepriceController.clear();
    cautionFeeController.clear();
    rideRulesController.clear();
    numOfPassController.clear();
    rideplateController.clear();
    rideIdNumController.clear();
    rideRegNoController.clear();
    rideColorController.clear();

    // Reset internal advert state (for text fields and derived values)
    state = RideAdvertState(
      rideType: '',
      features: [],
      rideImages: [],
    );

    // Reset individual providers (crucial!)
    final imagesProvider = mode == ProviderMode.create
        ? createRideImagePickerProvider
        : editRideImagePickerProvider;
    final amenitiesProvider = mode == ProviderMode.create
        ? createRideAmenitiesProvider
        : editRideAmenitiesProvider;
    final vehicleTypeProvider = mode == ProviderMode.create
          ? createVehicleType
          : editVehicleType;

    ref.read(imagesProvider.notifier).setRideImages([]);
    ref.read(amenitiesProvider.notifier).reset();
    ref.read(vehicleTypeProvider.notifier).reset();

    // Optionally reset textFieldProvider entries if needed
    final semanticLabels = ['Min. Price', 'No. Passenger'];
    for (final label in semanticLabels) {
      ref.read(textFieldProvider(label).notifier).updateText('');
    }
    _isDataLoaded = false;
  }
}

final createRideAdvertProvider =
    StateNotifierProvider<RideAdvertNotifier, RideAdvertState>((ref) {
  return RideAdvertNotifier(ref, ProviderMode.create);
});

final editRideAdvertProvider =
    StateNotifierProvider<RideAdvertNotifier, RideAdvertState>((ref) {
  return RideAdvertNotifier(ref, ProviderMode.edit);
});


String? _normalizeType(String? type) {
  if (type == null) return null;
  switch (type.toLowerCase()) {
    case 'car':
      return 'Car';
    case 'bus':
      return 'Bus';
    case 'bike':
      return 'Bike';
    case 'truck':
      return 'Truck';
    default:
      return type;
  }
}