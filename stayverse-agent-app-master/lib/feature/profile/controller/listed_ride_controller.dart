import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/profile/model/data/listed_rides_response.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayvers_agent/feature/profile/view/uistate/listed_ride_ui_state.dart';

class ListedRideController extends StateNotifier<ListedRideUiState>
    with CheckForServerError {
  ListedRideController(this._profileNetworkService)
      : super(const ListedRideUiState());

  final log = BrimLogger.load('ListedRideController');
  final ProfileNetworkService _profileNetworkService;

  Future<void> getListedRides(String status) async {
    try {
      _setRides(rides: []);
      _setLoading(true);

      final ServerResponse? response =
          await _profileNetworkService.getListedRides(status);

      if (errorOccured(response, showToast: false)) {
        return;
      }

      final ridesResponse = ListedRidesResponse.fromJson(
        response!.payload as DynamicMap,
      );

      _setRides(
        rides: ridesResponse.data?.rides ?? [],
      );
    } on BrimAppException catch (e) {
      log.i('getListedRides error: ${e.message}');
    } finally {
      _setLoading(false);
    }
  }

  void _setRides({
    required List<Ride> rides,
  }) {
    state = state.copyWith(
      rides: rides,
    );
  }

  void _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  reset() {
    _isBusy(false);
  }
}

final listedRideController =
    StateNotifierProvider.autoDispose<ListedRideController, ListedRideUiState>(
  (ref) => ListedRideController(locator.get()),
);
