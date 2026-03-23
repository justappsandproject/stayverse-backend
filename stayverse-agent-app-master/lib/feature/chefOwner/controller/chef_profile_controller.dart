import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_certification.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_experience_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_details_response.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/featured_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/dataSoruce/network/chef_profile_network_service.dart';
import 'package:stayvers_agent/feature/chefOwner/view/ui_state/chef_profile_ui_state.dart';

import '../model/data/chef_profile_response.dart';

class CreateChefController extends StateNotifier<ChefProfileUiState>
    with CheckForServerError {
  final ChefNetworkService _chefNetworkService;

  CreateChefController(this._chefNetworkService)
      : super(ChefProfileUiState(isBusy: false));

  Future<bool> createChefProfile(ChefProfileRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.createChefProfile(request);

      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Chef profile created successfully');
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> updateChefProfile(ChefProfileRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.updateChefProfile(request);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Chef profile updated successfully');
      getChefProfile();
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> addExperience(ExperienceRequest expRequest) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.addExperience(expRequest);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Experience added successfully');
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> addCertification(CertificationRequest certRequest) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.addCertification(certRequest);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Certification added successfully');
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<void> getChefProfile() async {
    final currentUser = BrimAuth.curentUser();
    try {
      _isBusy(true);
      ServerResponse? response = await _chefNetworkService
          .getChefProfile(currentUser?.agent?.id ?? '');

      if (errorOccured(response, showToast: false)) return;

      final responseData = response!.data as DynamicMap;
      final chefProfile = ChefProfileData.fromJson(responseData);
      _updateChefProfile(chefProfile);
    } catch (_) {
    } finally {
      reset();
    }
  }

  Future<bool> createFeatured(FeaturedRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.createFeatured(request);

      if (errorOccured(serverResponse)) return false;
      //call chef profile
      getChefProfile();
      BrimToast.showSuccess('Chef Featured added successfully');
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<void> getChefStatus() async {
    try {
      _isBusy(true);
      ServerResponse? response = await _chefNetworkService.getChefStatus();

      if (errorOccured(response, showToast: false)) return;

      final responseData = response!.data as DynamicMap;
      final chefStatus = ChefDetailsData.fromJson(responseData);
      _updateChefStatus(chefStatus);
    } catch (_) {
    } finally {
      reset();
    }
  }

  Future<bool> deleteExperience(String id) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.deleteExperience(id);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Experience deleted successfully');
      getChefProfile();
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> deleteCertification(String id) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.deleteCertification(id);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Certification deleted successfully');
      getChefProfile();
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> deleteFeatured(String id) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.deleteFeatured(id);
      if (errorOccured(serverResponse)) return false;

      BrimToast.showSuccess('Featured deleted successfully');
      getChefProfile();
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  void _updateChefProfile(ChefProfileData? chefProfileData) {
    if (chefProfileData == null) return;
    state = state.copyWith(profile: chefProfileData);
  }

  void _updateChefStatus(ChefDetailsData? chefDetailsData) {
    if (chefDetailsData == null) return;
    state = state.copyWith(status: chefDetailsData);
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final chefController =
    StateNotifierProvider<CreateChefController, ChefProfileUiState>((ref) {
  return CreateChefController(locator.get());
});
