import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class BookedApartmentDetailsArgs {
  final Booking? apartmentDetails;
  final bool? isCompleted;

  const BookedApartmentDetailsArgs({
    required this.apartmentDetails,
    this.isCompleted = false,
  });
}