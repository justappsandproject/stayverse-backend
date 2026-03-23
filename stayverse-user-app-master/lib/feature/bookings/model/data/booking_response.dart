import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/data/base_service.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/bookings/model/data/booking_base.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart'
    hide Agent;
import 'package:stayverse/feature/home/model/data/ride_response.dart';

class BookingResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  BookingResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  BookingResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      BookingResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
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
  final List<Booking>? data;
  final Pagination? pagination;

  Data({
    this.data,
    this.pagination,
  });

  Data copyWith({
    List<Booking>? data,
    Pagination? pagination,
  }) =>
      Data(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Booking>.from(json["data"]!.map((x) => Booking.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Booking implements BookingBase {
  final ServiceType? serviceType;
  final String? bookingId;
  final String? userId;
  final String? agentId;
  final String? rideId;

  final DateTime? startDate;
  final DateTime? endDate;

  final double? totalPrice;
  final double? cautionFee;

  final String? status;
  final String? paymentStatus;
  final String? escrowStatus;

  // NEW RIDE FIELDS
  final String? pickupAddress;
  final String? pickupPlaceId;
  final List<String>? securityDetails;
  final String? notes;

  // SERVICE OBJECTS
  final Ride? ride;
  final Chef? chef;
  final Apartment? apartment;
  final User? user;
  final Agent? agent;

  Booking({
    this.serviceType,
    this.bookingId,
    this.userId,
    this.agentId,
    this.rideId,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.cautionFee,
    this.status,
    this.paymentStatus,
    this.escrowStatus,
    this.pickupAddress,
    this.pickupPlaceId,
    this.securityDetails,
    this.notes,
    this.ride,
    this.chef,
    this.apartment,
    this.user,
    this.agent,
  });

  Booking copyWith({
    ServiceType? serviceType,
    String? bookingId,
    String? userId,
    String? agentId,
    String? rideId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    double? cautionFee,
    String? status,
    String? paymentStatus,
    String? escrowStatus,
    String? pickupAddress,
    String? pickupPlaceId,
    List<String>? securityDetails,
    String? notes,
    Ride? ride,
    Chef? chef,
    Apartment? apartment,
    User? user,
    Agent? agent,
  }) =>
      Booking(
        serviceType: serviceType ?? this.serviceType,
        bookingId: bookingId ?? this.bookingId,
        userId: userId ?? this.userId,
        agentId: agentId ?? this.agentId,
        rideId: rideId ?? this.rideId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalPrice: totalPrice ?? this.totalPrice,
        cautionFee: cautionFee ?? this.cautionFee,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        escrowStatus: escrowStatus ?? this.escrowStatus,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        pickupPlaceId: pickupPlaceId ?? this.pickupPlaceId,
        securityDetails: securityDetails ?? this.securityDetails,
        notes: notes ?? this.notes,
        ride: ride ?? this.ride,
        chef: chef ?? this.chef,
        apartment: apartment ?? this.apartment,
        user: user ?? this.user,
        agent: agent ?? this.agent,
      );

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        serviceType: ServiceType.fromValue(json["serviceType"]),
        bookingId: json["_id"],
        userId: json["userId"],
        agentId: json["agentId"],
        rideId: json["rideId"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        totalPrice: json["totalPrice"]?.toString().toDoubleOrNull(),
        cautionFee: json["cautionFee"]?.toString().toDoubleOrNull(),
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        escrowStatus: json["escrowStatus"],
        pickupAddress: json["pickupAddress"],
        pickupPlaceId: json["pickupPlaceId"],
        notes: json["notes"],
        securityDetails: json["securityDetails"] == null
            ? []
            : List<String>.from(json["securityDetails"].map((x) => x)),
        ride: json["ride"] == null ? null : Ride.fromJson(json["ride"]),
        chef: json["chef"] == null ? null : Chef.fromJson(json["chef"]),
        apartment: json["apartment"] == null
            ? null
            : Apartment.fromJson(json["apartment"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceType": serviceType?.apiPoint,
        "bookingId": bookingId,
        "userId": userId,
        "agentId": agentId,
        "rideId": rideId,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "totalPrice": totalPrice,
        "cautionFee": cautionFee,
        "status": status,
        "paymentStatus": paymentStatus,
        "escrowStatus": escrowStatus,
        "pickupAddress": pickupAddress,
        "pickupPlaceId": pickupPlaceId,
        "securityDetails": securityDetails,
        "notes": notes,
        "ride": ride?.toJson(),
        "chef": chef?.toJson(),
        "apartment": apartment?.toJson(),
        "user": user,
        "agent": agent?.toJson(),
      };

  @override
  String? get description {
    if (serviceType == null) {
      return '';
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment?.details;
      case ServiceType.chefs:
        return chef?.bio;
      case ServiceType.rides:
        return ride?.rideDescription;
    }
  }

  @override
  String? get imageUrl {
    if (serviceType == null) {
      return '';
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment?.apartmentImages?.firstOrNull;
      case ServiceType.chefs:
        return chef?.profilePicture;
      case ServiceType.rides:
        return ride?.rideImages?.firstOrNull;
    }
  }

  @override
  double? get price {
    if (serviceType == null) {
      return 0;
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment?.pricePerDay;
      case ServiceType.chefs:
        return chef?.pricingPerHour;
      case ServiceType.rides:
        return ride?.pricePerHour;
    }
  }

  @override
  String? get title {
    if (serviceType == null) {
      return '';
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment?.apartmentName;
      case ServiceType.chefs:
        return chef?.fullName;
      case ServiceType.rides:
        return ride?.rideName;
    }
  }

  @override
  BaseService? get service {
    if (serviceType == null) {
      return null;
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment!;
      case ServiceType.chefs:
        return chef!;
      case ServiceType.rides:
        return ride!;
    }
  }

  @override
  String? get address {
    if (serviceType == null) {
      return '';
    }
    switch (serviceType!) {
      case ServiceType.apartment:
        return apartment?.address;
      case ServiceType.chefs:
        return chef?.address;
      case ServiceType.rides:
        return ride?.address;
    }
  }
}

class Pagination {
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  Pagination copyWith({
    int? totalItems,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) =>
      Pagination(
        totalItems: totalItems ?? this.totalItems,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
        pageSize: pageSize ?? this.pageSize,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
      };
}
