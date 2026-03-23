import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class Ride {
  final String? id;
  final String? agentId;
  final String? rideName;
  final String? rideDescription;
  final String? address;
  final String? placeId;
  final Location? location;
  final String? rideType;
  final List<String>? features;
  final int? pricePerHour;
  final int? cautionFee;
  final String? rules;
  final int? maxPassengers;
  final List<String>? rideImages;
  final String? plateNumber;
  final String? registrationNumber;
  final String? color;
  final String? vehicleVerificationNumber;
  final String? bookedStatus;
  final String? status;
  final double? averageRating;
  final String? serviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.bookedStatus,
    this.status,
    this.averageRating,
    this.serviceType,
    this.createdAt,
    this.updatedAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json["_id"],
        agentId: json["agentId"],
        rideName: json["rideName"],
        rideDescription: json["rideDescription"],
        address: json["address"],
        placeId: json["placeId"],
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        rideType: json["rideType"],
        features: json["features"] != null
            ? List<String>.from(json["features"])
            : null,
        pricePerHour: json["pricePerHour"],
        cautionFee: json["cautionFee"],
        rules: json["rules"],
        maxPassengers: json["maxPassengers"],
        rideImages: json["rideImages"] != null
            ? List<String>.from(json["rideImages"])
            : null,
        plateNumber: json["plateNumber"],
        registrationNumber: json["registrationNumber"],
        color: json["color"],
        vehicleVerificationNumber: json["vehicleVerificationNumber"],
        bookedStatus: json["bookedStatus"],
        status: json["status"],
        averageRating: json["averageRating"]?.toDouble(),
        serviceType: json["serviceType"],
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
        "rideName": rideName,
        "rideDescription": rideDescription,
        "address": address,
        "placeId": placeId,
        "location": location?.toJson(),
        "rideType": rideType,
        "features": features,
        "pricePerHour": pricePerHour,
        "cautionFee": cautionFee,
        "rules": rules,
        "maxPassengers": maxPassengers,
        "rideImages": rideImages,
        "plateNumber": plateNumber,
        "registrationNumber": registrationNumber,
        "color": color,
        "vehicleVerificationNumber": vehicleVerificationNumber,
        "bookedStatus": bookedStatus,
        "status": status,
        "averageRating": averageRating,
        "serviceType": serviceType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}