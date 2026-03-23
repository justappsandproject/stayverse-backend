import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/debouncer.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/apartmentDetails/view/uistate/apartment_details_page_ui_state.dart';
import 'package:stayverse/feature/bookings/model/data/booked_days_response.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/booking_service_network.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_service.dart';

class ApartmentDetailsController extends StateNotifier<ApartmentDetailsUiState>
    with CheckForServerError {
  ApartmentDetailsController(
    this.ref,
    this._favoriteNetworkService,
    this._bookingNetworkService,
  ) : super(const ApartmentDetailsUiState());

  final logger = BrimLogger.load("ApartmentDetailsController");
  final Ref ref;
  final FavouriteNetworkService _favoriteNetworkService;
  final BookingNetworkService _bookingNetworkService;
  final debounce =
      DebouncerService(interval: const Duration(milliseconds: 150));

  void debounceFavourite({
    required ActionFavourite action,
    required String apartmentId,
  }) {
    debounce.call(
        () => _handleFavoriteAction(action: action, apartmentId: apartmentId),
        false);
  }

  Future<void> getUnavailableBookingDays(String apartmentId) async {
    try {
      final serverResponse =
          await _bookingNetworkService.getUnavailableBookingDays(
        serviceType: ServiceType.apartment.apiPoint,
        serviceId: apartmentId,
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
    required String apartmentId,
  }) async {
    if (state.isFavouriteBusy) return;

    final previousState = state.isFavourite;

    final newState = action == ActionFavourite.add;

    try {
      _updateIsFavourite(newState);
      _setFavouriteBusy(true);

      final serverResponse = await (action == ActionFavourite.add
          ? _favoriteNetworkService.addFavorite(
              FavouriteRequest(
                apartmentId: apartmentId,
                serviceType: ServiceType.apartment.apiPoint,
              ),
            )
          : _favoriteNetworkService.removeFavorite(
              FavouriteRequest(
                apartmentId: apartmentId,
                serviceType: ServiceType.apartment.apiPoint,
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
      ref.read(favouriteController.notifier).getApartmentFavourites();
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

final apartmentDetailsController = StateNotifierProvider.autoDispose<
        ApartmentDetailsController, ApartmentDetailsUiState>(
    (ref) => ApartmentDetailsController(ref, locator.get(), locator.get()));
