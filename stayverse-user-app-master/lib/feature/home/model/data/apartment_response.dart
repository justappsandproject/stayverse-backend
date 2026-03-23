import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/data/base_service.dart';
import 'package:stayverse/core/data/service_location.dart';

class ApartmentResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  ApartmentResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  ApartmentResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      ApartmentResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory ApartmentResponse.fromJson(Map<String, dynamic> json) =>
      ApartmentResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  final List<Apartment>? apartments;
  final Pagination? pagination;

  Data({
    this.apartments,
    this.pagination,
  });

  Data copyWith({
    List<Apartment>? apartments,
    Pagination? pagination,
  }) =>
      Data(
        apartments: apartments ?? this.apartments,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        apartments: json["apartments"] == null
            ? []
            : List<Apartment>.from(
                json["apartments"]!.map((x) => Apartment.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "apartments": apartments == null
            ? []
            : List<dynamic>.from(apartments!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Apartment implements BaseService {
  final String? id;
  final String? apartmentName;
  final String? details;
  final String? address;
  final String? placeId;
  final ServiceLocation? location;
  final String? apartmentType;
  final int? numberOfBedrooms;
  final List<String>? amenities;
  final double? pricePerDay;
  final double? cautionFee;
  final String? houseRules;
  final int? maxGuests;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final List<String>? apartmentImages;
  final String? status;
  final double? averageRating;
  final String? serviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? distance;
  final Agent? agent;
  final bool? isFavourite;

  Apartment({
    this.id,
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
    this.status,
    this.averageRating,
    this.serviceType,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.agent,
    this.isFavourite,
  });

  Apartment copyWith({
    String? id,
    String? agentId,
    String? apartmentName,
    String? details,
    String? address,
    String? placeId,
    ServiceLocation? location,
    String? apartmentType,
    int? numberOfBedrooms,
    List<String>? amenities,
    double? pricePerDay,
    double? cautionFee,
    String? houseRules,
    int? maxGuests,
    DateTime? checkIn,
    DateTime? checkOut,
    List<String>? apartmentImages,
    String? status,
    double? averageRating,
    String? serviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distance,
    Agent? agent,
    bool? isFavourite,
  }) =>
      Apartment(
        id: id ?? this.id,
        apartmentName: apartmentName ?? this.apartmentName,
        details: details ?? this.details,
        address: address ?? this.address,
        placeId: placeId ?? this.placeId,
        location: location ?? this.location,
        apartmentType: apartmentType ?? this.apartmentType,
        numberOfBedrooms: numberOfBedrooms ?? this.numberOfBedrooms,
        amenities: amenities ?? this.amenities,
        pricePerDay: pricePerDay ?? this.pricePerDay,
        cautionFee: cautionFee ?? this.cautionFee,
        houseRules: houseRules ?? this.houseRules,
        maxGuests: maxGuests ?? this.maxGuests,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        apartmentImages: apartmentImages ?? this.apartmentImages,
        status: status ?? this.status,
        averageRating: averageRating ?? this.averageRating,
        serviceType: serviceType ?? this.serviceType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        distance: distance ?? this.distance,
        agent: agent ?? this.agent,
        isFavourite: isFavourite ?? this.isFavourite,
      );

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
        id: json["_id"],
        apartmentName: json["apartmentName"],
        details: json["details"],
        address: json["address"],
        placeId: json["placeId"],
        location: json["location"] == null
            ? null
            : ServiceLocation.fromJson(json["location"]),
        apartmentType: json["apartmentType"],
        numberOfBedrooms: json["numberOfBedrooms"],
        amenities: json["amenities"] == null
            ? []
            : List<String>.from(json["amenities"]!.map((x) => x)),
        pricePerDay: json["pricePerDay"]?.toString().toDoubleOrNull(),
        cautionFee: json["cautionFee"]?.toString().toDoubleOrNull(),
        houseRules: json["houseRules"],
        maxGuests: json["maxGuests"],
        checkIn:
            json["checkIn"] == null ? null : DateTime.parse(json["checkIn"]),
        checkOut:
            json["checkOut"] == null ? null : DateTime.parse(json["checkOut"]),
        apartmentImages: json["apartmentImages"] == null
            ? []
            : List<String>.from(json["apartmentImages"]!.map((x) => x)),
        status: json["status"],
        averageRating: json["averageRating"]?.toString().toDoubleOrNull(),
        serviceType: json["serviceType"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        distance: json["distance"]?.toString().toDoubleOrNull(),
        agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "apartmentName": apartmentName,
        "details": details,
        "address": address,
        "placeId": placeId,
        "location": location?.toJson(),
        "apartmentType": apartmentType,
        "numberOfBedrooms": numberOfBedrooms,
        "amenities": amenities == null
            ? []
            : List<dynamic>.from(amenities!.map((x) => x)),
        "price": pricePerDay,
        "cautionFee": cautionFee,
        "houseRules": houseRules,
        "maxGuests": maxGuests,
        "checkIn": checkIn?.toIso8601String(),
        "checkOut": checkOut?.toIso8601String(),
        "apartmentImages": apartmentImages == null
            ? []
            : List<dynamic>.from(apartmentImages!.map((x) => x)),
        "status": status,
        "averageRating": averageRating,
        "serviceType": serviceType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "distance": distance,
        "agentId": agent?.toJson(),
        "isFavourite": isFavourite,
      };
}

class Agent {
  final String? id;
  final String? serviceType;
  final String? userId;
  final User? user;

  Agent({
    this.id,
    this.serviceType,
    this.userId,
    this.user,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["_id"],
        serviceType: json["serviceType"],
        userId: json["userId"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "userId": userId,
        "user": user,
      };
}

class User {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;

  User({
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        profilePicture: json["profilePicture"],
      );
}

class Pagination {
  final int? total;
  final int? totalPages;
  final int? currentPage;

  Pagination({
    this.total,
    this.totalPages,
    this.currentPage,
  });

  Pagination copyWith({
    int? total,
    int? totalPages,
    int? currentPage,
  }) =>
      Pagination(
        total: total ?? this.total,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}
