import 'package:fixed_collections/fixed_collections.dart';
import 'package:flutter/material.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/feature/search/model/data/car_search_filter.dart';
import 'package:stayverse/feature/search/model/data/chef_filter.dart';

@immutable
class SearchUiState {
  const SearchUiState(
      {this.isLoadingChefSearches = false,
      this.isLoadingApartmentSearches = false,
      this.isLoadingRideSearches = false,
      List<Apartment>? apartmentSearches,
      List<Chef>? chefSearches,
      List<Ride>? rideSearches,
      this.serviceType = ServiceType.apartment,
      ApartmentSearchFilter? apartmentFilter,
      CarSearchFilter? carSearchFilter,
      ChefSearchFilter? chefSearchFilter})
      : _apartmentSearches = apartmentSearches,
        _chefSearches = chefSearches,
        _rideSearches = rideSearches,
        _apartmentFilter = apartmentFilter,
        _carSearchFilter = carSearchFilter,
        _chefSearchFilter = chefSearchFilter;

  final List<Apartment>? _apartmentSearches;
  final List<Chef>? _chefSearches;
  final List<Ride>? _rideSearches;
  final ServiceType serviceType;
  final ApartmentSearchFilter? _apartmentFilter;
  final CarSearchFilter? _carSearchFilter;

  final ChefSearchFilter? _chefSearchFilter;

  ApartmentSearchFilter get apartmentFilter =>
      _apartmentFilter ?? ApartmentSearchFilter();

  CarSearchFilter get carFilter => _carSearchFilter ?? CarSearchFilter();

  ChefSearchFilter get chefFilter => _chefSearchFilter ?? ChefSearchFilter();

  FixedList<Apartment> get apartmentSearches =>
      FixedList(_apartmentSearches ?? []);

  FixedList<Chef> get chefSearches => FixedList(_chefSearches ?? []);

  FixedList<Ride> get rideSearches => FixedList(_rideSearches ?? []);

  final bool isLoadingChefSearches;
  final bool isLoadingApartmentSearches;
  final bool isLoadingRideSearches;

  SearchUiState copyWith({
    bool? isLoadingChefSearches,
    bool? isLoadingApartmentSearches,
    bool? isLoadingRideSearches,
    List<Apartment>? apartmentSearches,
    List<Chef>? chefSearches,
    List<Ride>? rideSearches,
    ServiceType? serviceType,
    ApartmentSearchFilter? apartmentFilter,
    CarSearchFilter? carSearchFilter,
    ChefSearchFilter? chefSearchFilter,
  }) {
    return SearchUiState(
      carSearchFilter: carSearchFilter ?? _carSearchFilter,
      apartmentSearches: apartmentSearches ?? _apartmentSearches,
      chefSearches: chefSearches ?? _chefSearches,
      rideSearches: rideSearches ?? _rideSearches,
      isLoadingChefSearches:
          isLoadingChefSearches ?? this.isLoadingChefSearches,
      isLoadingApartmentSearches:
          isLoadingApartmentSearches ?? this.isLoadingApartmentSearches,
      isLoadingRideSearches:
          isLoadingRideSearches ?? this.isLoadingRideSearches,
      serviceType: serviceType ?? this.serviceType,
      apartmentFilter: apartmentFilter ?? _apartmentFilter,
      chefSearchFilter: chefSearchFilter ?? _chefSearchFilter,
    );
  }
}
