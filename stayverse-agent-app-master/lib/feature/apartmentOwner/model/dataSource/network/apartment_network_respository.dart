import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/create_apartment_request.dart';

class _ApartmentPath {
  static String createapartment = "/apartment";
  static String updateApartment(String apartmentId) =>
      "/apartment/$apartmentId";
}

class ApartmentNetworkRespository {
  final log = BrimLogger.load("ApartmentRepository");

  ApartmentNetworkRespository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> createApartment(
      CreateApartmentRequest request) async {
    final formData = buildApartmentFormData(request);

    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ApartmentPath.createapartment}",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> updateApartment(
      String apartmentId, CreateApartmentRequest request) async {
    final formData = buildApartmentFormData(request);

    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_ApartmentPath.updateApartment(apartmentId)}",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
