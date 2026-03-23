import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/edit_apartment_ui_state.dart';

import '../model/data/create_apartment_request.dart';
import '../model/dataSource/network/apartment_network_service.dart';

class EditApartmentController extends StateNotifier<EditApartmentUiState>
    with CheckForServerError {
  EditApartmentController(this._apartmentNetworkService)
      : super(EditApartmentUiState(isBusy: false));

  final ApartmentNetworkService _apartmentNetworkService;

  Future<bool> editApartment(String apartmentId, CreateApartmentRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _apartmentNetworkService.editApartment(apartmentId, request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Apartment updated successfully');

      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final editApartmentController =
    StateNotifierProvider<EditApartmentController, EditApartmentUiState>((ref) {
  return EditApartmentController(locator.get());
});
