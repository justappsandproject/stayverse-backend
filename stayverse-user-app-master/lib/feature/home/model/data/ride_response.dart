import 'package:dart_extensions/dart_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/data/base_service.dart';

class RidesResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  RidesResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  RidesResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      RidesResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory RidesResponse.fromJson(Map<String, dynamic> json) => RidesResponse(
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
  final List<Ride>? rides;
  final Pagination? pagination;

  Data({
    this.rides,
    this.pagination,
  });

  Data copyWith({
    List<Ride>? rides,
    Pagination? pagination,
  }) =>
      Data(
        rides: rides ?? this.rides,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rides: json["rides"] == null
            ? []
            : List<Ride>.from(json["rides"]!.map((x) => Ride.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "rides": rides == null
            ? []
            : List<dynamic>.from(rides!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
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

class Ride implements BaseService {
  final String? id;
  final String? agentId;
  final String? rideName;
  final String? rideDescription;
  final String? address;
  final String? placeId;
  final Location? location;
  final String? rideType;
  final List<String>? features;
  final double? pricePerHour;
  final double? cautionFee;
  final String? rules;
  final int? maxPassengers;
  final List<String>? rideImages;
  final String? plateNumber;
  final String? registrationNumber;
  final String? color;
  final String? vehicleVerificationNumber;
  final bool? hasSecurity;
  final bool? hasAirportPickup;
  final String? status;
  final double? averageRating;
  final String? serviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isFavourite;
  final int? v;
  final RideAgent? agent;

  Ride({
    this.id,
    this.agentId,
    this.rideName,
    this.rideDescription,
    this.address,
    this.placeId,
    this.location,
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
    this.status,
    this.averageRating,
    this.serviceType,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isFavourite,
    this.agent,
  });

  Ride copyWith({
    String? id,
    String? agentId,
    String? rideName,
    String? rideDescription,
    String? address,
    String? placeId,
    Location? location,
    String? rideType,
    List<String>? features,
    double? pricePerHour,
    double? cautionFee,
    String? rules,
    int? maxPassengers,
    List<String>? rideImages,
    String? plateNumber,
    String? registrationNumber,
    String? color,
    String? vehicleVerificationNumber,
    bool? hasSecurity,
    bool? hasAirportPickup,
    String? status,
    double? averageRating,
    String? serviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavourite,
    int? v,
    RideAgent? agent,
  }) =>
      Ride(
        id: id ?? this.id,
        agentId: agentId ?? this.agentId,
        rideName: rideName ?? this.rideName,
        rideDescription: rideDescription ?? this.rideDescription,
        address: address ?? this.address,
        placeId: placeId ?? this.placeId,
        location: location ?? this.location,
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
        status: status ?? this.status,
        averageRating: averageRating ?? this.averageRating,
        serviceType: serviceType ?? this.serviceType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isFavourite: isFavourite ?? this.isFavourite,
        v: v ?? this.v,
        agent: agent ?? this.agent,
      );

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json["_id"],
        agentId: json["agentId"],
        rideName: json["rideName"],
        rideDescription: json["rideDescription"],
        address: json["address"],
        placeId: json["placeId"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        rideType: json["rideType"],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        pricePerHour: json["pricePerHour"]?.toString().toDoubleOrNull(),
        cautionFee: json["cautionFee"]?.toString().toDoubleOrNull(),
        rules: json["rules"],
        maxPassengers: json["maxPassengers"],
        rideImages: json["rideImages"] == null
            ? []
            : List<String>.from(json["rideImages"]!.map((x) => x)),
        plateNumber: json["plateNumber"],
        registrationNumber: json["registrationNumber"],
        color: json["color"],
        vehicleVerificationNumber: json["vehicleVerificationNumber"],
        hasSecurity: json["security"] == true,
        hasAirportPickup: json["airportPickup"] == true,
        status: json["status"],
        averageRating: json["averageRating"]?.toString().toDoubleOrNull(),
        serviceType: json["serviceType"],
        isFavourite: json["isFavourite"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        agent: json["agent"] == null ? null : RideAgent.fromJson(json["agent"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "agentId": agentId,
        "rideName": rideName,
        "rideDescription": rideDescription,
        "address": address,
        "placeId": placeId,
        "location": location?.toJson(),
        "isFavourite": isFavourite,
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
        "status": status,
        "averageRating": averageRating,
        "serviceType": serviceType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "agent": agent?.toJson(),
      };
}

class RideAgent {
  final String? id;
  final String? serviceType;
  final String? userId;
  final RideAgentUser? user;

  RideAgent({
    this.id,
    this.serviceType,
    this.userId,
    this.user,
  });

  factory RideAgent.fromJson(Map<String, dynamic> json) => RideAgent(
        id: json["_id"],
        serviceType: json["serviceType"],
        userId: json["userId"],
        user:
            json["user"] == null ? null : RideAgentUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "userId": userId,
        "user": user?.toJson(),
      };
}

class RideAgentUser {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;

  RideAgentUser({
    this.id,
    this.firstname,
    this.lastname,
    this.profilePicture,
    this.email,
    this.phoneNumber,
  });

  factory RideAgentUser.fromJson(Map<String, dynamic> json) => RideAgentUser(
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        profilePicture: json["profilePicture"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "profilePicture": profilePicture,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}

class Location {
  final String? type;
  final List<double>? coordinates;

  LatLng? get latLng => (coordinates == null || coordinates!.length != 2)
      ? null
      : LatLng(coordinates![1], coordinates![0]);

  Location({
    this.type,
    this.coordinates,
  });

  Location copyWith({
    String? type,
    List<double>? coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
