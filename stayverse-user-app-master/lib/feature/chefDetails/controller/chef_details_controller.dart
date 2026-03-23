import 'dart:async';

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
import 'package:stayverse/feature/chefDetails/view/uistate/chef_details_ui_state.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_service.dart';

class ChefDetailsController extends StateNotifier<ChefDetailsUistate>
    with CheckForServerError {
  ChefDetailsController(
    this.ref,
    this._favoriteNetworkService,
    this._bookingNetworkService,
  ) : super(const ChefDetailsUistate());

  final logger = BrimLogger.load("ApartmentDetailsController");
  final Ref ref;
  final FavouriteNetworkService _favoriteNetworkService;
  final BookingNetworkService _bookingNetworkService;
  final debounce =
      DebouncerService(interval: const Duration(milliseconds: 150));

  void debounceFavourite({
    required ActionFavourite action,
    required String chefId,
  }) {
    debounce.call(
        () => _handleFavoriteAction(action: action, chefId: chefId),
        false);
  }

  Future<void> getUnavailableBookingDays(String chefId) async {
    try {
      final serverResponse =
          await _bookingNetworkService.getUnavailableBookingDays(
        serviceType: ServiceType.chefs.apiPoint,
        serviceId: chefId,
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
    required String chefId,
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
                chefId: chefId,
                serviceType: ServiceType.chefs.apiPoint,
              ),
            )
          : _favoriteNetworkService.removeFavorite(
              FavouriteRequest(
                chefId: chefId,
                serviceType: ServiceType.chefs.apiPoint,
              ),
            ));

      if (errorOccured(serverResponse, showToast: false)) {
        _updateIsFavourite(previousState);
        return;
      }
      _refreshFavouriteList();
    } on BrimAppException catch (e) {
      _updateIsFavourite(previousState);
      logger.e("Error handling favorite action: ${e.message}");
    } finally {
      _setFavouriteBusy(false);
    }
  }

  void _refreshFavouriteList() {
    if (mounted) {
      ref.read(favouriteController.notifier).getChefFavourites();
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

final chefDetailsController = StateNotifierProvider.autoDispose<
        ChefDetailsController, ChefDetailsUistate>(
    (ref) => ChefDetailsController(ref, locator.get(), locator.get()));
