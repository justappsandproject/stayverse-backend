import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/debouncer.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/bookings/model/data/booked_days_response.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/booking_service_network.dart';
import 'package:stayverse/feature/carDetails/view/uistate/car_details_page_ui_state.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_repository.dart';

class CarDetailsController extends StateNotifier<CarDetailsUiState>
    with CheckForServerError {
  CarDetailsController(
    this.ref,
    this._bookingNetworkService,
    this._favouriteNetworkRepository,
  ) : super(const CarDetailsUiState());

  final logger = BrimLogger.load("CarDetailsController");
  final Ref ref;
  final FavouriteNetworkRepository _favouriteNetworkRepository;
  final BookingNetworkService _bookingNetworkService;
  final debounce =
      DebouncerService(interval: const Duration(milliseconds: 150));

  void debounceFavourite({
    required ActionFavourite action,
    required String rideId,
  }) {
    debounce.call(
        () => _handleFavoriteAction(action: action, rideId: rideId), false);
  }

  Future<void> getUnavailableBookingDays(String rideId) async {
    try {
      final serverResponse =
          await _bookingNetworkService.getUnavailableBookingDays(
        serviceType: ServiceType.rides.apiPoint,
        serviceId: rideId,
      );
      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final unavailableDays =
          BookedDaysResponse.fromJson(serverResponse?.payload as DynamicMap);

      state = state.copyWith(bookedDays: unavailableDays.data ?? []);
    } on BrimAppException catch (e) {
      logger.e("Error handling favorite action: ${e.message}");
    }
  }

  Future<void> _handleFavoriteAction({
    required ActionFavourite action,
    required String rideId,
  }) async {
    if (state.isFavouriteBusy) return;

    final previousState = state.isFavourite;

    final newState = action == ActionFavourite.add;

    try {
      _updateIsFavourite(newState);
      _setFavouriteBusy(true);

      final serverResponse = await (action == ActionFavourite.add
          ? _favouriteNetworkRepository.addFavorite(
              FavouriteRequest(
                rideId: rideId,
                serviceType: ServiceType.rides.apiPoint,
              ),
            )
          : _favouriteNetworkRepository.removeFavorite(
              FavouriteRequest(
                rideId: rideId,
                serviceType: ServiceType.rides.apiPoint,
              ),
            ));

      if (errorOccured(serverResponse, showToast: false)) {
        _updateIsFavourite(previousState);
        return;
      }
      _refreshFavouriteList();
    } on BrimAppException catch (e) {
      // Revert to previous state on exception
      _updateIsFavourite(previousState);
      logger.e("Error handling favorite action: ${e.message}");
    } finally {
      _setFavouriteBusy(false);
    }
  }

  void _refreshFavouriteList() {
    if (mounted) {
      ref.read(favouriteController.notifier).getRideFavourites();
    }
  }

  void _updateIsFavourite(bool? isFavourite) {
    if (mounted) {
      state = state.copyWith(isFavourite: isFavourite);
    }
  }

  void _setFavouriteBusy(bool isFavouriteBusy) {
    if (mounted) {
      state = state.copyWith(isFavouriteBusy: isFavouriteBusy);
    }
  }
}

final carDetailsController =
    StateNotifierProvider.autoDispose<CarDetailsController, CarDetailsUiState>(
  (ref) => CarDetailsController(ref, locator.get(), locator.get()),
);
