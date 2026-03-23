import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/profile/model/data/listed_apartments_response.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayvers_agent/feature/profile/view/uistate/listed_apartment_ui_state.dart';

class ListedApartmentController extends StateNotifier<ListedApartmentUiState>
    with CheckForServerError {
  ListedApartmentController(this._profileNetworkService)
      : super(const ListedApartmentUiState());

  final log = BrimLogger.load('ListedApartmentController');
  final ProfileNetworkService _profileNetworkService;

  Future<void> getListedApartments(String status) async {
    try {
      _setApartments(apartments: []);
      _setLoading(true);

      final ServerResponse? response =
          await _profileNetworkService.getListedApartments(status);

      if (errorOccured(response, showToast: false)) {
        return;
      }

      final apartmentsResponse = ListedApartmentsResponse.fromJson(
        response!.payload as DynamicMap,
      );

      _setApartments(
        apartments: apartmentsResponse.data?.apartments ?? [],
      );
    } on BrimAppException catch (e) {
      log.i('getListedApartments error: ${e.message}');
    } finally {
      _setLoading(false);
    }
  }

  void _setApartments({
    required List<Apartment> apartments,
  }) {
    state = state.copyWith(
      apartments: apartments,
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

final listedApartmentController = StateNotifierProvider.autoDispose<
    ListedApartmentController, ListedApartmentUiState>(
  (ref) => ListedApartmentController(locator.get()),
);
