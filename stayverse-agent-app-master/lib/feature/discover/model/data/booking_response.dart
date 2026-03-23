import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';

// Main response wrapper that matches your API structure
class BookingApiResponse {
  final String? message;
  final BookingData? data;
  final dynamic error;

  BookingApiResponse({
    this.message,
    this.data,
    this.error,
  });

  BookingApiResponse copyWith({
    bool? error,
    String? message,
    BookingData? data,
  }) =>
      BookingApiResponse(
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory BookingApiResponse.fromJson(Map<String, dynamic> json) {
    return BookingApiResponse(
      message: json['message'] ?? '',
      data: json["data"] == null ? null : BookingData.fromJson(json["data"]),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'data': data?.toJson(),
        'error': error,
      };
}

// Data wrapper containing bookings and pagination
class BookingData {
  final List<Booking>? bookings;
  final Pagination? pagination;

  BookingData({
    this.bookings,
    this.pagination,
  });

  BookingData copyWith({
    List<Booking>? bookings,
    Pagination? pagination,
  }) =>
      BookingData(
        bookings: bookings ?? this.bookings,
        pagination: pagination ?? this.pagination,
      );

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookings: json["data"] == null
          ? []
          : List<Booking>.from(json["data"]!.map((x) => Booking.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": bookings == null
            ? []
            : List<dynamic>.from(bookings!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

// Main booking model - renamed from ApartmentBooking to handle all service types
class Booking {
  final String? id;
  final String? serviceType;
  final String? userId;
  final String? agentId;
  final String? rideId;
  final String? chefId;
  final String? apartmentId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? totalPrice;
  final int? cautionFee;
  final String? pickupAddress;
  final String? pickupPlaceId;
  final String? status;
  final String? paymentStatus;
  final String? escrowStatus;
  final List<String>? securityDetails; 
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final BookingUser? user;
  final AgentInfo? agent;
  final Apartment? apartment;
  final Ride? ride;

  Booking({
    this.id,
    this.serviceType,
    this.userId,
    this.agentId,
    this.rideId,
    this.chefId,
    this.apartmentId,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.cautionFee,
    this.pickupAddress,
    this.pickupPlaceId,
    this.status,
    this.paymentStatus,
    this.escrowStatus,
    this.securityDetails,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.user,
    this.agent,
    this.apartment,
    this.ride,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["_id"],
        serviceType: json["serviceType"],
        userId: json["userId"],
        agentId: json["agentId"],
        apartmentId: json["apartmentId"],
        rideId: json["rideId"],
        chefId: json["chefId"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        totalPrice: json["totalPrice"],
        cautionFee: json["cautionFee"],
        pickupAddress: json["pickupAddress"],
        pickupPlaceId: json["pickupPlaceId"],
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        escrowStatus: json["escrowStatus"],
        securityDetails: json["securityDetails"] != null
            ? List<String>.from(json["securityDetails"])
            : null,
        notes: json["notes"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
        user: json["user"] != null ? BookingUser.fromJson(json["user"]) : null,
        agent: json["agent"] != null ? AgentInfo.fromJson(json["agent"]) : null,
        apartment: json["apartment"] != null
            ? Apartment.fromJson(json["apartment"])
            : null,
        ride: json["ride"] != null ? Ride.fromJson(json["ride"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "userId": userId,
        "agentId": agentId,
        "apartmentId": apartmentId,
        "rideId": rideId,
        "chefId": chefId,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "totalPrice": totalPrice,
        "cautionFee": cautionFee,
        "pickupAddress": pickupAddress,
        "pickupPlaceId": pickupPlaceId,
        "status": status,
        "paymentStatus": paymentStatus,
        "escrowStatus": escrowStatus,
        "securityDetails": securityDetails,
        "notes": notes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "user": user?.toJson(),
        "agent": agent?.toJson(),
        "apartment": apartment?.toJson(),
        "ride": ride?.toJson(),
      };
}

// Keep your existing models (BookingUser, AgentInfo, AgentUser, Apartment, Location)
class BookingUser {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final bool? isEmailVerified;
  final DateTime? lastSeenAt;
  final String? profilePicture;

  BookingUser({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.isEmailVerified,
    this.lastSeenAt,
    this.profilePicture,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) => BookingUser(
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        isEmailVerified: json["isEmailVerified"],
        lastSeenAt: json["lastSeenAt"] != null
            ? DateTime.parse(json["lastSeenAt"])
            : null,
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "isEmailVerified": isEmailVerified,
        "lastSeenAt": lastSeenAt?.toIso8601String(),
        "profilePicture": profilePicture,
      };
}

class AgentInfo {
  final String? id;
  final String? serviceType;
  final String? userId; // ✅ Changed: This should be a string ID
  final AgentUser? user; // ✅ Added: The actual user object
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgentInfo({
    this.id,
    this.serviceType,
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory AgentInfo.fromJson(Map<String, dynamic> json) => AgentInfo(
        id: json["_id"],
        serviceType: json["serviceType"],
        userId: json["userId"], // ✅ Fixed: Keep as string
        user: json["user"] != null
            ? AgentUser.fromJson(json["user"])
            : null, // ✅ Fixed: Parse the actual user object
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "userId": userId, // ✅ Fixed: Keep as string
        "user": user?.toJson(), // ✅ Fixed: Serialize the user object
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

// Keep your existing AgentUser class as is
class AgentUser {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final bool? isEmailVerified;
  final String? socketId;
  final DateTime? lastSeenAt;
  final String? otp;
  final DateTime? pinExpires;

  AgentUser({
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.isEmailVerified,
    this.socketId,
    this.lastSeenAt,
    this.otp,
    this.pinExpires,
  });

  factory AgentUser.fromJson(Map<String, dynamic> json) => AgentUser(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber:
            json["phoneNumber"] ?? json["phoneNum"], // Handle both field names
        isEmailVerified: json["isEmailVerified"],
        socketId: json["socketId"],
        lastSeenAt: json["lastSeenAt"] != null
            ? DateTime.parse(json["lastSeenAt"])
            : null,
        otp: json["otp"],
        pinExpires: json["pinExpires"] != null
            ? DateTime.parse(json["pinExpires"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "isEmailVerified": isEmailVerified,
        "socketId": socketId,
        "lastSeenAt": lastSeenAt?.toIso8601String(),
        "otp": otp,
        "pinExpires": pinExpires?.toIso8601String(),
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

// Pagination model
class Pagination {
  final int? page;
  final int? limit;
  final int? total;
  final int? pages;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.pages,
  });

  Pagination copyWith({
    int? page,
    int? limit,
    int? total,
    int? pages,
  }) =>
      Pagination(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        total: total ?? this.total,
        pages: pages ?? this.pages,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "pages": pages,
      };
}
