import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_certification.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_experience_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_proposal_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/featured_request.dart';

class _ChefPath {
  static String createProfile = "/chef";
  static String addExperience = "/chef/experience";
  static String addCertification = "/chef/certification";
  static String getChefProfile(String chefId) => "/chef/profile/$chefId";
  static String createFeatured = "/chef/feature";
  static String getChefStatus = "/chef/has-details";
  static String createChefProposal(String id) => "/chef/$id/proposal";
  static String deleteExperience(String id) => "/chef/experience/$id";
  static String deleteCertification(String id) => "/chef/certification/$id";
  static String deleteFeatured(String id) => "/chef/feature/$id";
}

class ChefNetworkRepository {
  final Dio dio;
  final log = BrimLogger.load("ChefRepository");

  ChefNetworkRepository({required this.dio});

  Future<ServerResponse?> createChefProfile(ChefProfileRequest request) async {
    final formData = await buildChefProfileFormData(request);

    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.createProfile}",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }


    Future<ServerResponse?> updateChefProfile(ChefProfileRequest request) async {
    final formData = await buildChefProfileFormData(request);

    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.createProfile}",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> addExperience(ExperienceRequest expRequest) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.addExperience}",
      data: expRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> addCertification(CertificationRequest certRequest) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.addCertification}",
      data: certRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

   Future<ServerResponse?> getChefProfile(String chefId) async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_ChefPath.getChefProfile(chefId)}");
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

    Future<ServerResponse?> createFeatured(FeaturedRequest request) async {
    final formData = await buildFeaturedFormData(request);

    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.createFeatured}",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getChefStatus() async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_ChefPath.getChefStatus}");
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }


  Future<ServerResponse?> createChefProposal(String id, ChefProposalRequest request) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.createChefProposal(id)}",
      data: request.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> deleteExperience(String id) async {
    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.deleteExperience(id)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> deleteCertification(String id) async {
    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.deleteCertification(id)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> deleteFeatured(String id) async {
    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_ChefPath.deleteFeatured(id)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}