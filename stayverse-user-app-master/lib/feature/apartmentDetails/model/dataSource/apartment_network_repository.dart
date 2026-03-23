import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';

// ignore: unused_element
class _ApartmentDetailsPath {
  static const String booking = "/booking";
}

class ApartmentDetailsRepository {
  final log = BrimLogger.load("ApartmentDetailsRepository");

  ApartmentDetailsRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> bookService(BookingRequest bookingRequest) async {  
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ApartmentDetailsPath.booking}",
      data: bookingRequest.toJson(),
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
