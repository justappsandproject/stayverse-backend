import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';

abstract class AparmentDetailsDataSource<T> {

  Future<T?> bookService(BookingRequest bookingRequest);
}
