import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/image_picker_ui_state.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/create_ride_request.dart';

class RideAdvertState {
  final String? rideName;
  final String? rideDescription;
  final String? address;
  final String? placeId;
  final String? rideType;
  final List<String>? features;
  final double? pricePerHour;
  final double? cautionFee;
  final String? rules;
  final int? maxPassengers;
  final List<ImageFile>? rideImages;
  final String? plateNumber;
  final String? registrationNumber;
  final String? color;
  final String? vehicleVerificationNumber;

  RideAdvertState({
    this.rideName = '',
    this.rideDescription = '',
    this.address = '',
    this.placeId = '',
    this.rideType = 'Car',
    this.features = const [],
    this.pricePerHour = 0.0,
    this.cautionFee = 0.0,
    this.rules = '',
    this.maxPassengers = 0,
    this.rideImages = const [],
    this.plateNumber = '',
    this.registrationNumber = '',
    this.color = '',
    this.vehicleVerificationNumber = '',
  });

  RideAdvertState copyWith({
    String? rideName,
    String? rideDescription,
    String? address,
    String? placeId,
    String? rideType,
    List<String>? features,
    double? pricePerHour,
    double? cautionFee,
    String? rules,
    int? maxPassengers,
    List<ImageFile>? rideImages,
    String? plateNumber,
    String? registrationNumber,
    String? color,
    String? vehicleVerificationNumber,
  }) {
    return RideAdvertState(
      rideName: rideName ?? this.rideName,
      rideDescription: rideDescription ?? this.rideDescription,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      rideType: rideType ?? this.rideType,
      features: features ?? this.features,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      cautionFee: cautionFee ?? this.cautionFee,
      rules: rules ?? this.rules,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      rideImages: rideImages ?? this.rideImages,
      plateNumber: plateNumber ?? this.plateNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      color: color ?? this.color,
      vehicleVerificationNumber:
          vehicleVerificationNumber ?? this.vehicleVerificationNumber,
    );
  }

  // Convert to CreateRideRequest
  CreateRideRequest toCreateRideRequest() {
    return CreateRideRequest(
      rideName: rideName,
      rideDescription: rideDescription,
      address: address,
      placeId: placeId,
      rideType: rideType,
      features: features,
      pricePerHour: pricePerHour,
      cautionFee: cautionFee,
      rules: rules,
      maxPassengers: maxPassengers,
      rideImages: rideImages,
      plateNumber: plateNumber,
      registrationNumber: registrationNumber,
      color: color,
      vehicleVerificationNumber: vehicleVerificationNumber,
    );
  }
}
