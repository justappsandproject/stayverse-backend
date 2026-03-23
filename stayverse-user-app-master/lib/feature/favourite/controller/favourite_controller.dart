import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_reponse.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_service.dart';
import 'package:stayverse/feature/favourite/view/uistate/ui_state.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';

class FavoriteController extends StateNotifier<FavouriteUiState>
    with CheckForServerError {
  FavoriteController(this._favouriteNetworkRepository)
      : super(const FavouriteUiState());

  final logger = BrimLogger.load(FavoriteController);

  final FavouriteNetworkService _favouriteNetworkRepository;
  Future<void> getChefFavourites() async {
    state = state.copyWith(isLoadingChefFavourite: true);

    try {
      final serverResponse =
          await _favouriteNetworkRepository.getFavourites(ServiceType.chefs);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          FavouriteResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateChefFavourite(
        response.data?.data
            ?.map((value) => value.chef)
            .whereType<Chef>()
            .toList(),
      );
    } on BrimAppException catch (e) {
      logger.e("Error fetching chef recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingChefFavourite: false);
    }
  }

  Future<void> getApartmentFavourites() async {
    state = state.copyWith(isLoadingApartmentFavourite: true);

    try {
      final serverResponse = await _favouriteNetworkRepository
          .getFavourites(ServiceType.apartment);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          FavouriteResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateApartmentFavourite(
        response.data?.data
            ?.map((value) => value.apartment)
            .whereType<Apartment>()
            .toList(),
      );
    } on BrimAppException catch (e) {
      logger.e("Error fetching apartment recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingApartmentFavourite: false);
    }
  }

  Future<void> getRideFavourites() async {
    state = state.copyWith(isLoadingRideFavourite: true);

    try {
      final serverResponse =
          await _favouriteNetworkRepository.getFavourites(ServiceType.rides);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          FavouriteResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateRideFavourite(
        response.data?.data
            ?.map((value) => value.ride)
            .whereType<Ride>()
            .toList(),
      );
    } on BrimAppException catch (e) {
      logger.e("Error fetching ride recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingRideFavourite: false);
    }
  }

  _updateApartmentFavourite(List<Apartment>? apartmentFavourite) {
    state = state.copyWith(
        apartmentFavourite: apartmentFavourite
            ?.map((e) => e.copyWith(
                  isFavourite: true,
                ))
            .toList());
  }

  _updateRideFavourite(List<Ride>? rideFavourite) {
    state = state.copyWith(
        rideFavourite: rideFavourite
            ?.map((e) => e.copyWith(
                  isFavourite: true,
                ))
            .toList());
  }

  _updateChefFavourite(List<Chef>? chefFavourite) {
    state = state.copyWith(
        chefFavourite: chefFavourite
            ?.map((e) => e.copyWith(
                  isFavorite: true,
                ))
            .toList());
  }
}

final favouriteController =
    StateNotifierProvider<FavoriteController, FavouriteUiState>(
        (ref) => FavoriteController(locator.get()));
