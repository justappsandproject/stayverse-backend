import 'package:fixed_collections/fixed_collections.dart';
import 'package:flutter/material.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/home/model/data/search_bar_data.dart';
import 'package:stayverse/shared/app_icons.dart';

@immutable
class HomeUiState {
  const HomeUiState({
    this.searchBarData = const SearchBarData(
      'Search Places',
      AppIcons.shortlet,
      ServiceType.apartment,
    ),
    this.isLoadingChefRecommendations = false,
    this.isLoadingApartmentRecommendations = false,
    this.isLoadingRideRecommendations = false,
    this.isLoadingNewlyListedApartments = false,
    this.isLoadingNewlyListedChefs = false,
    this.isLoadingNewlyListedRides = false,
    List<Apartment>? apartmentRecommendations,
    List<Chef>? chefRecommendations,
    List<Ride>? rideRecommendations,
    List<Apartment>? newlyListedApartments,
    List<Chef>? newlyListedChefs,
    List<Ride>? newlyListedRides,
  })  : _apartmentRecommendations = apartmentRecommendations,
        _chefRecommendations = chefRecommendations,
        _rideRecommendations = rideRecommendations,
        _newlyListedApartments = newlyListedApartments,
        _newlyListedChefs = newlyListedChefs,
        _newlyListedRides = newlyListedRides;

  final List<Apartment>? _apartmentRecommendations;
  final List<Chef>? _chefRecommendations;
  final List<Ride>? _rideRecommendations;

  final List<Apartment>? _newlyListedApartments;
  final List<Chef>? _newlyListedChefs;
  final List<Ride>? _newlyListedRides;

  final SearchBarData searchBarData;

  FixedList<Apartment> get apartmentRecommendations =>
      FixedList(_apartmentRecommendations ?? []);

  FixedList<Chef> get chefRecommendations =>
      FixedList(_chefRecommendations ?? []);
  FixedList<Ride> get rideRecommendations =>
      FixedList(_rideRecommendations ?? []);

  FixedList<Apartment> get newlyListedApartments =>
      FixedList(_newlyListedApartments ?? []);
  FixedList<Chef> get newlyListedChefs => FixedList(_newlyListedChefs ?? []);
  FixedList<Ride> get newlyListedRides => FixedList(_newlyListedRides ?? []);

  final bool isLoadingChefRecommendations;
  final bool isLoadingApartmentRecommendations;
  final bool isLoadingRideRecommendations;
  final bool isLoadingNewlyListedApartments;
  final bool isLoadingNewlyListedChefs;
  final bool isLoadingNewlyListedRides;

  HomeUiState copyWith({
    bool? isLoadingChefRecommendations,
    bool? isLoadingApartmentRecommendations,
    bool? isLoadingRideRecommendations,
    List<Apartment>? apartmentRecommendations,
    List<Chef>? chefRecommendations,
    List<Ride>? rideRecommendations,
    bool? isLoadingNewlyListedApartments,
    bool? isLoadingNewlyListedChefs,
    bool? isLoadingNewlyListedRides,
    List<Apartment>? newlyListedApartments,
    List<Chef>? newlyListedChefs,
    List<Ride>? newlyListedRides,
    SearchBarData? searchBarData,
  }) {
    return HomeUiState(
      isLoadingNewlyListedApartments:
          isLoadingNewlyListedApartments ?? this.isLoadingNewlyListedApartments,
      isLoadingNewlyListedChefs:
          isLoadingNewlyListedChefs ?? this.isLoadingNewlyListedChefs,
      isLoadingNewlyListedRides:
          isLoadingNewlyListedRides ?? this.isLoadingNewlyListedRides,
      newlyListedApartments: newlyListedApartments ?? _newlyListedApartments,
      newlyListedChefs: newlyListedChefs ?? _newlyListedChefs,
      newlyListedRides: newlyListedRides ?? _newlyListedRides,
      searchBarData: searchBarData ?? this.searchBarData,
      apartmentRecommendations:
          apartmentRecommendations ?? _apartmentRecommendations,
      chefRecommendations: chefRecommendations ?? _chefRecommendations,
      rideRecommendations: rideRecommendations ?? _rideRecommendations,
      isLoadingChefRecommendations:
          isLoadingChefRecommendations ?? this.isLoadingChefRecommendations,
      isLoadingApartmentRecommendations: isLoadingApartmentRecommendations ??
          this.isLoadingApartmentRecommendations,
      isLoadingRideRecommendations:
          isLoadingRideRecommendations ?? this.isLoadingRideRecommendations,
    );
  }
}
