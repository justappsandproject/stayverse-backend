import 'package:dio/dio.dart' as dio;

class CreateRideRequest {
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
  final List<dynamic>? rideImages;
  final String? plateNumber;
  final String? registrationNumber;
  final String? color;
  final String? vehicleVerificationNumber;
  final bool? hasSecurity;
  final bool? hasAirportPickup;

  CreateRideRequest({
    this.rideName,
    this.rideDescription,
    this.address,
    this.placeId,
    this.rideType,
    this.features,
    this.pricePerHour,
    this.cautionFee,
    this.rules,
    this.maxPassengers,
    this.rideImages,
    this.plateNumber,
    this.registrationNumber,
    this.color,
    this.vehicleVerificationNumber,
    this.hasSecurity,
    this.hasAirportPickup,
  });

  CreateRideRequest copyWith({
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
    List<dynamic>? rideImages,
    String? plateNumber,
    String? registrationNumber,
    String? color,
    String? vehicleVerificationNumber,
    bool? hasSecurity,
    bool? hasAirportPickup,
  }) =>
      CreateRideRequest(
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
        hasSecurity: hasSecurity ?? this.hasSecurity,
        hasAirportPickup: hasAirportPickup ?? this.hasAirportPickup,
      );

  factory CreateRideRequest.fromJson(Map<String, dynamic> json) =>
      CreateRideRequest(
        rideName: json["rideName"],
        rideDescription: json["rideDescription"],
        address: json["address"],
        placeId: json["placeId"],
        rideType: json["rideType"],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"].map((x) => x)),
        pricePerHour: json["pricePerHour"]?.toDouble(),
        cautionFee: json["cautionFee"]?.toDouble(),
        rules: json["rules"],
        maxPassengers: json["maxPassengers"],
        rideImages: json["rideImages"] == null
            ? []
            : List<dynamic>.from(json["rideImages"].map((x) => x)),
        plateNumber: json["plateNumber"],
        registrationNumber: json["registrationNumber"],
        color: json["color"],
        vehicleVerificationNumber: json["vehicleVerificationNumber"],
        hasSecurity: json["security"] == true,
        hasAirportPickup: json["airportPickup"] == true,
      );

  Map<String, dynamic> toJson() => {
        "rideName": rideName,
        "rideDescription": rideDescription,
        "address": address,
        "placeId": placeId,
        "rideType": rideType,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "pricePerHour": pricePerHour,
        "cautionFee": cautionFee,
        "rules": rules,
        "maxPassengers": maxPassengers,
        "rideImages": rideImages == null
            ? []
            : List<dynamic>.from(rideImages!.map((x) => x)),
        "plateNumber": plateNumber,
        "registrationNumber": registrationNumber,
        "color": color,
        "vehicleVerificationNumber": vehicleVerificationNumber,
        "security": hasSecurity ?? false,
        "airportPickup": hasAirportPickup ?? false,
      };
}

dio.FormData buildRideFormData(CreateRideRequest request) {
  final formData = dio.FormData();

  _addRideTextFields(formData, request);
  _addFeatures(formData, request.features);
  _addRideImages(formData, request.rideImages);

  return formData;
}

void _addRideTextFields(dio.FormData formData, CreateRideRequest request) {
  final fields = <String, dynamic>{
    'rideName': request.rideName,
    'rideDescription': request.rideDescription,
    'address': request.address,
    'placeId': request.placeId,
    'rideType': request.rideType?.toLowerCase(),
    'pricePerHour': request.pricePerHour?.toString(),
    'cautionFee': request.cautionFee?.toString(),
    'rules': request.rules,
    'maxPassengers': request.maxPassengers?.toString(),
    'plateNumber': request.plateNumber,
    'registrationNumber': request.registrationNumber,
    'color': request.color,
    'vehicleVerificationNumber': request.vehicleVerificationNumber,
    'security': request.hasSecurity == true ? 'true' : 'false',
    'airportPickup': request.hasAirportPickup == true ? 'true' : 'false',
  };

  fields.forEach((key, value) {
    if (value != null) {
      formData.fields.add(MapEntry(key, value));
    }
  });
}

void _addFeatures(dio.FormData formData, List<String>? features) {
  if (features == null || features.isEmpty) return;

  for (int i = 0; i < features.length; i++) {
    formData.fields.add(MapEntry('features[$i]', features[i]));
  }
}

void _addRideImages(dio.FormData formData, List<dynamic>? images) {
  if (images == null || images.isEmpty) return;

  for (final image in images) {
    if (image is dio.MultipartFile) {
      formData.files.add(MapEntry('rideImages', image));
    }
  }
}
