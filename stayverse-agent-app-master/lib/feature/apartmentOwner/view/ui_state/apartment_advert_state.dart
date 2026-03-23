import 'package:stayvers_agent/feature/apartmentOwner/model/data/create_apartment_request.dart';

import 'image_picker_ui_state.dart';

class ApartmentAdvertState {
  final String? apartmentName;
  final String? details;
  final String? location;
  final String? selectedPlaceId;
  final String? apartmentType;
  final int? numberOfBathrooms;
  final List<ImageFile>? apartmentImages;
  final List<String>? amenities;
  final double? pricePerDay;
  final double? cautionFee;
  final String? houseRules;
  final int? maxGuests;
  final String? checkIn;
  final String? checkOut;

  ApartmentAdvertState({
    this.apartmentName = '',
    this.details = '',
    this.location = '',
    this.selectedPlaceId = '',
    this.apartmentType = 'Studio',
    this.numberOfBathrooms = 0,
    this.apartmentImages = const [],
    this.amenities = const [],
    this.pricePerDay = 0.0,
    this.cautionFee = 0.0,
    this.houseRules = '',
    this.maxGuests = 0,
    this.checkIn = '',
    this.checkOut = '',
  });

  ApartmentAdvertState copyWith({
    String? apartmentName,
    String? details,
    String? location,
    String? selectedPlaceId,
    String? apartmentType,
    int? numberOfBathrooms,
    List<ImageFile>? apartmentImages,
    List<String>? amenities,
    double? pricePerDay,
    double? cautionFee,
    String? houseRules,
    int? maxGuests,
    String? checkIn,
    String? checkOut,
  }) {
    return ApartmentAdvertState(
      apartmentName: apartmentName ?? this.apartmentName,
      details: details ?? this.details,
      location: location ?? this.location,
      selectedPlaceId: selectedPlaceId ?? this.selectedPlaceId,
      apartmentType: apartmentType ?? this.apartmentType,
      numberOfBathrooms: numberOfBathrooms ?? this.numberOfBathrooms,
      apartmentImages: apartmentImages ?? this.apartmentImages,
      amenities: amenities ?? this.amenities,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      cautionFee: cautionFee ?? this.cautionFee,
      houseRules: houseRules ?? this.houseRules,
      maxGuests: maxGuests ?? this.maxGuests,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  // Convert to CreateApartmentRequest
  CreateApartmentRequest toCreateApartmentRequest() {

    return CreateApartmentRequest(
      apartmentName: apartmentName,
      details: details,
      address: location,
      placeId: selectedPlaceId,
      apartmentType: apartmentType,
      numberOfBedrooms: numberOfBathrooms, 
      amenities: amenities,
      pricePerDay: pricePerDay,
      cautionFee: cautionFee,
      houseRules: houseRules,
      maxGuests: maxGuests,
      checkIn: checkIn,
      checkOut: checkOut,
      apartmentImages: apartmentImages,
    );
  }
}