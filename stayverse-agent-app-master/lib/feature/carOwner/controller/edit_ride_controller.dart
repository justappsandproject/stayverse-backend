import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/carOwner/model/dataSource/network/ride_network_service.dart';
import 'package:stayvers_agent/feature/carOwner/view/ui_state/edit_ride_ui_state.dart';

import '../model/data/create_ride_request.dart';

class EditRideController extends StateNotifier<EditRideUiState>
    with CheckForServerError {
  EditRideController(this._rideNetworkService)
      : super(EditRideUiState(isBusy: false));

  final RideNetworkService _rideNetworkService;

  Future<bool> editRide(String rideId, CreateRideRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _rideNetworkService.editRide(rideId, request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Ride updated successfully');

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

final editRideController =
    StateNotifierProvider<EditRideController, EditRideUiState>((ref) {
  return EditRideController(locator.get());
});