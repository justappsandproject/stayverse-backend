import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/location/location_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/home/model/data/search_bar_data.dart';
import 'package:stayverse/feature/home/model/dataSource/network/home_network_service.dart';
import 'package:stayverse/feature/home/view/uistate/home_ui_state.dart';

class HomeController extends StateNotifier<HomeUiState>
    with CheckForServerError {
  HomeController(this._homeNetworkService) : super(const HomeUiState());

  final logger = BrimLogger.load(HomeController);

  final HomeNetworkService _homeNetworkService;

  Future<void> getNewlyListedApartment() async {
    state = state.copyWith(isLoadingNewlyListedApartments: true);

    try {
      final serverResponse =
          await _homeNetworkService.getNewlyListed(ServiceType.apartment);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final response =
          ApartmentResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateNewlyListedApartments(response.data?.apartments);
    } on BrimAppException catch (e) {
      logger.e("Error fetching chef recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingNewlyListedApartments: false);
    }
  }

  Future<void> getNewlyListedChef() async {
    state = state.copyWith(isLoadingNewlyListedChefs: true);

    try {
      final serverResponse =
          await _homeNetworkService.getNewlyListed(ServiceType.chefs);
      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final rideResponse =
          ChefResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateNewlyListedChefs(rideResponse.data?.chefs);
    } on BrimAppException catch (e) {
      logger.e("Error fetching chef recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingNewlyListedChefs: false);
    }
  }

  Future<void> getNewlyListedRide() async {
    state = state.copyWith(isLoadingNewlyListedRides: true);

    try {
      final serverResponse =
          await _homeNetworkService.getNewlyListed(ServiceType.rides);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final rideResponse =
          RidesResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateNewlyListedRides(rideResponse.data?.rides);
    } on BrimAppException catch (e) {
      logger.e("Error fetching chef recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingNewlyListedRides: false);
    }
  }

  Future<void> getChefRecommendations() async {
    state = state.copyWith(isLoadingChefRecommendations: true);

    try {
      final currenLocation = await LocationService.currentLocation();

      final serverResponse = await _homeNetworkService.getRecommendations(
          ServiceType.chefs, currenLocation ?? Constant.defaultLocation);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final chefResponse =
          ChefResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateChefRecommendations(chefResponse.data?.chefs);
    } on BrimAppException catch (e) {
      logger.e("Error fetching chef recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingChefRecommendations: false);
    }
  }

  Future<void> getRideRecommendations() async {
    state = state.copyWith(isLoadingRideRecommendations: true);

    try {
      final currenLocation = await LocationService.currentLocation();
      final serverResponse = await _homeNetworkService.getRecommendations(
          ServiceType.rides, currenLocation ?? Constant.defaultLocation);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          RidesResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateRideRecommendations(response.data?.rides);
    } on BrimAppException catch (e) {
      logger.e("Error fetching ride recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingRideRecommendations: false);
    }
  }

  Future<void> getApartmentRecommendations() async {
    state = state.copyWith(isLoadingApartmentRecommendations: true);

    try {
      final currenLocation = await LocationService.currentLocation();

      final serverResponse = await _homeNetworkService.getRecommendations(
          ServiceType.apartment, currenLocation ?? Constant.defaultLocation);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final response =
          ApartmentResponse.fromJson(serverResponse?.payload as DynamicMap);

      _updateApartmentRecommendations(response.data?.apartments);
    } on BrimAppException catch (e) {
      logger.e("Error fetching ride recommendations: ${e.message}");
    } finally {
      state = state.copyWith(isLoadingApartmentRecommendations: false);
    }
  }

  void _updateApartmentRecommendations(
      List<Apartment>? apartmentRecommendations) {
    state = state.copyWith(apartmentRecommendations: apartmentRecommendations);
  }

  void _updateChefRecommendations(List<Chef>? chefRecommendations) {
    state = state.copyWith(chefRecommendations: chefRecommendations);
  }

  void _updateRideRecommendations(List<Ride>? rideRecommendations) {
    state = state.copyWith(rideRecommendations: rideRecommendations);
  }

  void _updateNewlyListedApartments(List<Apartment>? newlyListedApartments) {
    state = state.copyWith(newlyListedApartments: newlyListedApartments);
  }

  void _updateNewlyListedChefs(List<Chef>? newlyListedChefs) {
    state = state.copyWith(newlyListedChefs: newlyListedChefs);
  }

  void _updateNewlyListedRides(List<Ride>? newlyListedRides) {
    state = state.copyWith(newlyListedRides: newlyListedRides);
  }

  void updateSearchBarData(SearchBarData data) {
    state = state.copyWith(searchBarData: data);
  }
}

final homeController = StateNotifierProvider<HomeController, HomeUiState>(
    (ref) => HomeController(locator.get()));
