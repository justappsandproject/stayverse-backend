import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_certification.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_experience_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_data_source.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_proposal_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/featured_request.dart';

import 'chef_profile_network_repository.dart';

class ChefNetworkService extends ChefDataSource<ServerResponse> {
  final ChefNetworkRepository _chefRepository;
  final log = BrimLogger.load("ChefService");

  ChefNetworkService(this._chefRepository);

  @override
  Future<ServerResponse?> createChefProfile(ChefProfileRequest request) async {
    try {
      log.i("::::====> Creating Chef Profile");
      return await _chefRepository.createChefProfile(request);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

    @override
  Future<ServerResponse?> updateChefProfile(ChefProfileRequest request) async {
    try {
      log.i("::::====> Updating Chef Profile");
      return await _chefRepository.updateChefProfile(request);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> addExperience(ExperienceRequest expRequest) async {
    try {
      log.i("::::====> Adding Experience");
      return await _chefRepository.addExperience(expRequest);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> addCertification(CertificationRequest certRequest) async {
    try {
      log.i("::::====> Adding Certification");
      return await _chefRepository.addCertification(certRequest);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getChefProfile(String chefId) async {
    try {
      log.i("  ::::====>  fetching ChefProfile with id: $chefId");

      return await _chefRepository.getChefProfile(chefId);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> createFeatured(FeaturedRequest request) async {
    try {
      log.i("::::====> Creating Chef Featured");
      return await _chefRepository.createFeatured(request);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getChefStatus() async {
    try {
      log.i("  ::::====>  fetching ChefStatus");

      return await _chefRepository.getChefStatus();
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

    @override
  Future<ServerResponse?> createChefProposal(String id, ChefProposalRequest request) async {
    try {
      log.i("::::====> Creating Chef Proposal");
      return await _chefRepository.createChefProposal(id, request);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteExperience(String id) async {
    try {
      log.i("::::====> Deleting Experience with id: $id");
      return await _chefRepository.deleteExperience(id);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteCertification(String id) async {
    try {
      log.i("::::====> Deleting Certification with id: $id");
      return await _chefRepository.deleteCertification(id);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteFeatured(String id) async {
    try {
      log.i("::::====> Deleting Featured with id: $id");
      return await _chefRepository.deleteFeatured(id);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}