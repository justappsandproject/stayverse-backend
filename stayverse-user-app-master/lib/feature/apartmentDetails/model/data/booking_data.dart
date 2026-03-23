import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';

class BookingData {
  final Apartment? apartment;
  final DateTimeRange dateRange;
  final double totalPrice;
  final double apartmentPrice;
  final double cautionFee;

  BookingData({
    required this.apartment,
    required this.dateRange,
    required this.totalPrice,
    required this.apartmentPrice,
    required this.cautionFee,
  });
}
