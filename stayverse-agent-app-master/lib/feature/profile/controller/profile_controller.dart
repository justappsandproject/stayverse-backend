import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/service/image_service.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/wrapper/notification/pusher/pusher.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/profile/model/data/update_password_request.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayvers_agent/feature/profile/view/uistate/profile_ui_state.dart';

class ProfileController extends StateNotifier<ProfileUiState>
    with CheckForServerError {
  ProfileController(this._profileNetworkService, this.ref)
      : super(const ProfileUiState());

  final Ref ref;

  final ProfileNetworkService _profileNetworkService;

  Future<bool> updatePassword(
      UpdatePasswordRequest updatePasswordRequest) async {
    try {
      _isBusy(true);
      final serverResponse =
          await _profileNetworkService.updatePassword(updatePasswordRequest);

      if (errorOccured(serverResponse)) {
        return false;
      }
      BrimToast.showSuccess('Password updated successfully');
      return true;
    } catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      _isBusy(false);
    }
  }

  Future<bool> uploadProfile(File profilePicture) async {
    try {
      _isLoadingProfile(true);
      final profileFile =
          await ImageService.convertImagetoMultipart(profilePicture.path);
      final serverResponse =
          await _profileNetworkService.uploadProfile(profileFile);

      if (errorOccured(serverResponse)) {
        return false;
      }
      BrimToast.showSuccess('Profile uploaded successfully');
      return true;
    } catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      _isLoadingProfile(false);
    }
  }

  Future<void> updateNotificationPreference(bool enabled) async {
    _isUpdatingNotification(true);
    try {
      final success = await BrimPusher.pushToken(notificationsEnabled: enabled);
      if (success != null) {
        await ref.read(dashboadController.notifier).refreshUser();
      }
    } finally {
      _isUpdatingNotification(false);
    }
  }

  _isUpdatingNotification(bool isUpdating) {
    state = state.copyWith(isUpdatingNotification: isUpdating);
  }

  _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  _isLoadingProfile(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  reset() {
    _isBusy(false);
  }
}

final profileController =
    StateNotifierProvider<ProfileController, ProfileUiState>(
  (ref) => ProfileController(locator.get(), ref),
);
