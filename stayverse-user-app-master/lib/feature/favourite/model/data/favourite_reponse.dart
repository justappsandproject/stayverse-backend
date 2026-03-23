import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';

class FavouriteResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  FavouriteResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  FavouriteResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      FavouriteResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory FavouriteResponse.fromJson(Map<String, dynamic> json) =>
      FavouriteResponse(
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
  final List<FavouriteData>? data;
  final Pagination? pagination;

  Data({
    this.data,
    this.pagination,
  });

  Data copyWith({
    List<FavouriteData>? data,
    Pagination? pagination,
  }) =>
      Data(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<FavouriteData>.from(
                json["data"]!.map((x) => FavouriteData.fromJson(x))),
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

class FavouriteData {
  final String? id;

  final String? serviceType;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  final Apartment? apartment;
  final Ride? ride;
  final Chef? chef;

  FavouriteData({
    this.id,
    this.serviceType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.apartment,
    this.ride,
    this.chef,
  });

  FavouriteData copyWith({
    String? id,
    String? serviceType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Apartment? apartment,
    Ride? ride,
    Chef? chef,
  }) =>
      FavouriteData(
        id: id ?? this.id,
        serviceType: serviceType ?? this.serviceType,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        apartment: apartment ?? this.apartment,
        ride: ride ?? this.ride,
        chef: chef ?? this.chef,
      );

  factory FavouriteData.fromJson(Map<String, dynamic> json) => FavouriteData(
        id: json["_id"],
        serviceType: json["serviceType"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        ride: json["ride"] == null
            ? null
            : Ride.fromJson({
                ...json["ride"],
                if (json["agent"] != null) "agent": json["agent"],
              }),
        chef: json["chef"] == null
            ? null
            : Chef.fromJson({
                ...json["chef"],
                if (json["agent"] != null) "agent": json["agent"],
              }),
        apartment: json["apartment"] == null
            ? null
            : Apartment.fromJson({
                ...json["apartment"],
                if (json["agent"] != null) "agent": json["agent"],
              }),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "apartment": apartment?.toJson(),
        "ride": ride?.toJson(),
        "chef": chef?.toJson(),
      };
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
