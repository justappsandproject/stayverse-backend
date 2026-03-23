import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/service/image_service.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayvers_agent/feature/profile/view/uistate/kyc_ui_state.dart';

class KycController extends StateNotifier<KycUiState> with CheckForServerError {
  KycController(this._profileNetworkService) : super(const KycUiState());

  final ProfileNetworkService _profileNetworkService;

  Future<bool> verifyKyc(String nin, File selfie) async {
    try {
      _isBusy(true);
      final selfieFile = await ImageService.convertImagetoMultipart(selfie.path);
      final serverResponse =
          await _profileNetworkService.verifyKyc(nin, selfieFile);

      if (errorOccured(serverResponse)) {
        return false;
      }
      BrimToast.showSuccess('KYC verified successfully');
      return true;
    } catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      _isBusy(false);
    }
  }

  _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  reset() {
    _isBusy(false);
  }
}

final kycController =
    StateNotifierProvider<KycController, KycUiState>(
  (ref) => KycController(locator.get()),
);
