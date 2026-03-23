import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class Apartment {
  final String? id;
  final String? agentId;
  final String? apartmentName;
  final String? details;
  final String? address;
  final String? placeId;
  final Location? location;
  final String? apartmentType;
  final int? numberOfBedrooms;
  final List<String>? amenities;
  final int? pricePerDay;
  final int? cautionFee;
  final String? houseRules;
  final int? maxGuests;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final List<String>? apartmentImages;
  final String? bookedStatus;
  final String? status;
  final double? averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Apartment({
    this.id,
    this.agentId,
    this.apartmentName,
    this.details,
    this.address,
    this.placeId,
    this.location,
    this.apartmentType,
    this.numberOfBedrooms,
    this.amenities,
    this.pricePerDay,
    this.cautionFee,
    this.houseRules,
    this.maxGuests,
    this.checkIn,
    this.checkOut,
    this.apartmentImages,
    this.bookedStatus,
    this.status,
    this.averageRating,
    this.createdAt,
    this.updatedAt,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
        id: json["_id"],
        agentId: json["agentId"],
        apartmentName: json["apartmentName"],
        details: json["details"],
        address: json["address"],
        placeId: json["placeId"],
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        apartmentType: json["apartmentType"],
        numberOfBedrooms: json["numberOfBedrooms"],
        amenities: json["amenities"] != null
            ? List<String>.from(json["amenities"])
            : null,
        pricePerDay: json["pricePerDay"],
        cautionFee: json["cautionFee"],
        houseRules: json["houseRules"],
        maxGuests: json["maxGuests"],
        checkIn:
            json["checkIn"] != null ? DateTime.parse(json["checkIn"]) : null,
        checkOut:
            json["checkOut"] != null ? DateTime.parse(json["checkOut"]) : null,
        apartmentImages: json["apartmentImages"] != null
            ? List<String>.from(json["apartmentImages"])
            : null,
        bookedStatus: json["bookedStatus"],
        status: json["status"],
        averageRating: json["averageRating"]?.toDouble(),
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "agentId": agentId,
        "apartmentName": apartmentName,
        "details": details,
        "address": address,
        "placeId": placeId,
        "location": location?.toJson(),
        "apartmentType": apartmentType,
        "numberOfBedrooms": numberOfBedrooms,
        "amenities": amenities,
        "pricePerDay": pricePerDay,
        "cautionFee": cautionFee,
        "houseRules": houseRules,
        "maxGuests": maxGuests,
        "checkIn": checkIn?.toIso8601String(),
        "checkOut": checkOut?.toIso8601String(),
        "apartmentImages": apartmentImages,
        "bookedStatus": bookedStatus,
        "status": status,
        "averageRating": averageRating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}