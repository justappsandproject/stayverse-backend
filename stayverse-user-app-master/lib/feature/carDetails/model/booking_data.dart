import 'package:stayverse/feature/home/model/data/ride_response.dart';

class RideBookingData {
  final Ride? ride;
  final List<String> securityDetails;
  final String pickupPlaceId;
  final DateTime? pickUpDateTime;
  final int totalHours;
  final String additionalReq;
  final double totalPrice;
  final double ridePrice;
  final double cautionFee;

  RideBookingData({
    required this.ride,
    required this.securityDetails,
    required this.pickupPlaceId,
    required this.pickUpDateTime,
    required this.totalHours,
    required this.additionalReq,
    required this.totalPrice,
    required this.ridePrice,
    required this.cautionFee,
  });
}
