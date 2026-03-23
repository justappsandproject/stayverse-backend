import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/aparment_details_data_source.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';
import 'package:stayverse/feature/apartmentDetails/model/dataSource/apartment_network_repository.dart';

class AparmentDetailsNetworkService
    extends AparmentDetailsDataSource<ServerResponse> {
  final log = BrimLogger.load("AparmentDetailsNetworkService");
  final ApartmentDetailsRepository _apartmentDetailsRepository;

  AparmentDetailsNetworkService(this._apartmentDetailsRepository);

  @override
  Future<ServerResponse?> bookService(BookingRequest bookingRequest) async {
    try {
      log.i("::::====> Booking bookService");

      return await _apartmentDetailsRepository.bookService(bookingRequest);
    } on DioException catch (e) {
      log.i("Error  Fetching booking: ${e.message}");
      log.i("Error  Fetching booking status: ${e.response?.statusCode}");
      log.i("Error  Fetching booking data: ${e.response?.data}");
      return BrimAppException.handleError(e);
    }
  }
}
