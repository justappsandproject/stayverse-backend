import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class BookedRideDetailsArgs {
  final Booking? rideDetails;
  final bool? isCompleted;

  const BookedRideDetailsArgs({
    required this.rideDetails,
    this.isCompleted = false,
  });
}