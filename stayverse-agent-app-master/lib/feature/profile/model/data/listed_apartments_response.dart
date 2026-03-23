import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class ListedApartmentsResponse {
  final String? message;
  final ApartmentData? data;
  final dynamic error;

  ListedApartmentsResponse({
    this.message,
    this.data,
    this.error,
  });

  factory ListedApartmentsResponse.fromJson(Map<String, dynamic> json) {
    return ListedApartmentsResponse(
      message: json['message'],
      data: json["data"] == null ? null : ApartmentData.fromJson(json["data"]),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class ApartmentData {
  final List<Apartment>? apartments;
  final Pagination? pagination;

  ApartmentData({
    this.apartments,
    this.pagination,
  });

  factory ApartmentData.fromJson(Map<String, dynamic> json) {
    return ApartmentData(
      apartments: json["apartments"] == null
          ? []
          : List<Apartment>.from(
              json["apartments"]!.map((x) => Apartment.fromJson(x))),
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "apartments": apartments?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };
}