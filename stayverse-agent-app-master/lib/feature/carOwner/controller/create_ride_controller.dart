import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/carOwner/model/dataSource/network/ride_network_service.dart';
import 'package:stayvers_agent/feature/carOwner/view/ui_state/create_ride_ui_state.dart';

import '../model/data/create_ride_request.dart';

class CreateRideController extends StateNotifier<CreateRideUiState>
    with CheckForServerError {
  CreateRideController(this._rideNetworkService)
      : super(CreateRideUiState(isBusy: false));

  final RideNetworkService _rideNetworkService;

  Future<bool> createRide(CreateRideRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _rideNetworkService.createRide(request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Ride created successfully');

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

final rideController =
    StateNotifierProvider<CreateRideController, CreateRideUiState>((ref) {
  return CreateRideController(locator.get());
});
