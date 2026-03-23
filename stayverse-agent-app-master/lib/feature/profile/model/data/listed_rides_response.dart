import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class ListedRidesResponse {
  final String? message;
  final RideData? data;
  final dynamic error;

  ListedRidesResponse({
    this.message,
    this.data,
    this.error,
  });

  factory ListedRidesResponse.fromJson(Map<String, dynamic> json) {
    return ListedRidesResponse(
      message: json['message'],
      data: json["data"] == null ? null : RideData.fromJson(json["data"]),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class RideData {
  final List<Ride>? rides;
  final Pagination? pagination;

  RideData({
    this.rides,
    this.pagination,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      rides: json["rides"] == null
          ? []
          : List<Ride>.from(json["rides"]!.map((x) => Ride.fromJson(x))),
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "rides": rides?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };
}
