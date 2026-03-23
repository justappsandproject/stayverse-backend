import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/create_apartment_ui_state.dart';

import '../model/data/create_apartment_request.dart';
import '../model/dataSource/network/apartment_network_service.dart';

class CreateApartmentController extends StateNotifier<CreateApartmentUiState>
    with CheckForServerError {
  CreateApartmentController(this._apartmentNetworkService)
      : super(CreateApartmentUiState(isBusy: false));

  final ApartmentNetworkService _apartmentNetworkService;

  Future<bool> createApartment(CreateApartmentRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _apartmentNetworkService.createApartment(request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Apartment created successfully');

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

final apartmentController =
    StateNotifierProvider<CreateApartmentController, CreateApartmentUiState>(
        (ref) {
  return CreateApartmentController(locator.get());
});
