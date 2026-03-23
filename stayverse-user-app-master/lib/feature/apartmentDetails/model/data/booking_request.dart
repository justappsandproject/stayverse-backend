import 'package:stayverse/core/data/enum/enums.dart';

class BookingRequest {
  ServiceType? serviceType;
  String? apartmentId;
  String? rideId;
  String? chefId;
  DateTime? startDate;
  DateTime? endDate;
  double? totalAmout;
  String? pickupPlaceId;
  int? totalHours;
  String? additionalRequest;
  List<String>? securityDetails;

  BookingRequest({
    this.serviceType,
    this.apartmentId,
    this.rideId,
    this.chefId,
    this.startDate,
    this.endDate,
    this.totalAmout,
    this.pickupPlaceId,
    this.totalHours,
    this.additionalRequest,
    this.securityDetails,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      serviceType: ServiceType.fromValue(json['serviceType']),
      apartmentId: json['apartmentId'],
      rideId: json['rideId'],
      chefId: json['chefId'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      totalAmout: json['totalAmout'],
      pickupPlaceId: json['pickupPlaceId'],
      totalHours: json['totalHours'],
      additionalRequest: json['notes'],
      securityDetails: json['securityDetails'] != null ? List<String>.from(json['securityDetails']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceType': serviceType?.apiPoint,
      'apartmentId': apartmentId,
      'rideId': rideId,
      'chefId': chefId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'totalAmout': totalAmout,
      'pickupPlaceId': pickupPlaceId,
      'totalHours': totalHours,
      'notes': additionalRequest,
      'securityDetails': securityDetails,
    };
  }
}
