import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/util/location/location_privacy.dart';
import 'package:stayverse/core/util/app/debouncer.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/search/controller/map_controller.dart';
import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/feature/search/model/data/car_search_filter.dart';
import 'package:stayverse/feature/search/model/data/chef_filter.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';
import 'package:stayverse/feature/search/model/dataSource/network/search_network_service.dart';
import 'package:stayverse/feature/search/view/uistate/search_ui_state.dart';

// Updated SearchFilterController with complete chef search implementation

class SearchFilterController extends StateNotifier<SearchUiState>
    with CheckForServerError {
  SearchFilterController(this._searchNetworkService, this.ref)
      : super(const SearchUiState());

  final Ref ref;
  final SearchNetworkService _searchNetworkService;

  ServiceType get serviceType => state.serviceType;
  final _logger = BrimLogger.load('SearchController');
  final debouncer =
      DebouncerService(interval: const Duration(milliseconds: 350));

  void debounceSearch(String query, {bool? callImmediately}) {
    debouncer.call(() {
      search(query);
    }, callImmediately ?? false);
  }

  Future<void> search(String query) async {
    switch (serviceType) {
      case ServiceType.apartment:
        updateApartmentFilter(searchTerm: query);
        await searchApartmentsWithFilter();
        break;
      case ServiceType.chefs:
        updateChefFilter(searchTerm: query);
        await searchChefs(query);
        break;
      case ServiceType.rides:
        updateCarFilter(searchTerm: query);
        await searchRides(query);
        break;
    }
  }

  // Existing apartment search method (unchanged)
  Future<void> searchApartmentsWithFilter() async {
    try {
      _isLoadingApartmentSearches(true);

      final serverResponse = await _searchNetworkService.searchApartments(
        state.apartmentFilter,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          ApartmentResponse.fromJson(serverResponse?.payload as DynamicMap);

      updateAparmentSearches(response.data?.apartments);
      _flushInAPartments(response.data?.apartments ?? []);
    } catch (e) {
      _logger.e('Search apartments error $e');
    } finally {
      _isLoadingApartmentSearches(false);
    }
  }

  // COMPLETED CHEF SEARCH METHOD
  Future<void> searchChefs(String query) async {
    try {
      _isLoadingChefSearches(true);

      final serverResponse = await _searchNetworkService.searchChef(
        state.chefFilter,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          ChefResponse.fromJson(serverResponse?.payload as DynamicMap);

      updateChefSearches(response.data?.chefs);
      _flushInChefs(response.data?.chefs ?? []);
    } catch (e) {
      _logger.e('Search chefs error $e');
    } finally {
      _isLoadingChefSearches(false);
    }
  }

  Future<void> searchRides(String query) async {
    try {
      _isLoadingCarSearches(true);

      final serverResponse = await _searchNetworkService.searchRides(
        state.carFilter,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }

      final response =
          RidesResponse.fromJson(serverResponse?.payload as DynamicMap);

      updateCarSearches(response.data?.rides);
      _fluseInRide(response.data?.rides ?? []);
    } catch (e) {
      _logger.e('Search rides error $e');
    } finally {
      _isLoadingCarSearches(false);
    }
  }

  // Existing apartment flush method (unchanged)
  void _flushInAPartments(List<Apartment> apartments) {
    if (!mounted) return;
    final mapDataList = apartments.map((apartment) {
      return MapData(
          id: apartment.id,
          price: MoneyServiceV2.formatNaira(apartment.pricePerDay ?? 0,
              decimalDigits: 0),
          imageUrl: apartment.apartmentImages?.firstOrNull,
          title: apartment.apartmentName,
          location: LocationPrivacy.extractArea(apartment.address),
          period: 'day',
          position: apartment.location?.latLng,
          searchResult: apartment);
    }).toList();
    ref.read(mapController.notifier).flushInData(mapDataList);
  }

  // NEW CHEF FLUSH METHOD
  void _flushInChefs(List<Chef> chefs) {
    if (!mounted) return;
    final mapDataList = chefs.map((chef) {
      return MapData(
          id: chef.id,
          price: MoneyServiceV2.formatNaira(chef.pricingPerHour ?? 0,
              decimalDigits: 0),
          imageUrl: chef.coverPhoto,
          title: chef.fullName,
          location: chef.address,
          period: 'hour',
          position: chef.location?.latLng,
          searchResult: chef);
    }).toList();
    ref.read(mapController.notifier).flushInData(mapDataList);
  }

  // Existing ride flush method (unchanged)
  void _fluseInRide(List<Ride> rides) {
    if (!mounted) return;
    final mapDataList = rides.map((ride) {
      return MapData(
          id: ride.id,
          price: MoneyServiceV2.formatNaira(ride.pricePerHour ?? 0,
              decimalDigits: 0),
          imageUrl: ride.rideImages?.firstOrNull,
          title: ride.rideName,
          location: ride.address,
          period: 'hr',
          position: ride.location?.latLng,
          searchResult: ride);
    }).toList();
    ref.read(mapController.notifier).flushInData(mapDataList);
  }

  // Existing apartment filter methods (unchanged)
  void updateApartmentFilter({
    String? searchTerm,
    double? minPrice,
    double? maxPrice,
    int? numberOfBedrooms,
    List<String>? amenities,
    DateTime? moveInDate,
  }) {
    final currentFilter = state.apartmentFilter;

    final updatedFilter = currentFilter.copyWith(
      searchTerm: searchTerm,
      minPrice: minPrice,
      maxPrice: maxPrice,
      numberOfBedrooms: numberOfBedrooms,
      amenities: amenities,
      moveInDate: moveInDate,
    );

    state = state.copyWith(apartmentFilter: updatedFilter);
  }

  void resetApartmentFilter() {
    state = state.copyWith(apartmentFilter: ApartmentSearchFilter());
  }

  // NEW CHEF FILTER METHODS
  void updateChefFilter({
    String? searchTerm,
    List<String>? culinarySpecialties,
    double? minPrice,
    double? maxPrice,
    double? lat,
    double? lng,
    double? radius,
    int? limit,
    int? page,
  }) {
    final currentFilter = state.chefFilter;

    final updatedFilter = currentFilter.copyWith(
      searchTerm: searchTerm,
      culinarySpecialties: culinarySpecialties,
      minPrice: minPrice,
      maxPrice: maxPrice,
      lat: lat,
      lng: lng,
      radius: radius,
      limit: limit,
      page: page,
    );

    state = state.copyWith(chefSearchFilter: updatedFilter);
  }

  void resetChefFilter() {
    state = state.copyWith(chefSearchFilter: ChefSearchFilter());
  }

  void updateCarFilter({
    int? limit,
    int? page,
    double? radius,
    double? lng,
    double? lat,
    List<String>? features,
    double? maxPrice,
    double? minPrice,
    String? rideType,
    String? searchTerm,
    String? description,
    DateTime? pickupDate,
  }) {
    state = state.copyWith(
      carSearchFilter: state.carFilter.copyWith(
        limit: limit,
        page: page,
        radius: radius,
        lng: lng,
        lat: lat,
        features: features,
        maxPrice: maxPrice,
        minPrice: minPrice,
        rideType: rideType,
        searchTerm: searchTerm,
        description: description,
        pickupDate: pickupDate,
      ),
    );
  }

  void resetCarFilter() {
    state = state.copyWith(
      carSearchFilter: CarSearchFilter(),
    );
  }

  // Loading state methods
  void _isLoadingApartmentSearches(bool isLoading) {
    state = state.copyWith(isLoadingApartmentSearches: isLoading);
  }

  void _isLoadingChefSearches(bool isLoading) {
    state = state.copyWith(isLoadingChefSearches: isLoading);
  }

  void _isLoadingCarSearches(bool isLoading) {
    state = state.copyWith(isLoadingRideSearches: isLoading);
  }

  // Update search results methods
  void updateAparmentSearches(List<Apartment>? aparmentSearches) {
    state = state.copyWith(apartmentSearches: aparmentSearches);
  }

  void updateChefSearches(List<Chef>? chefSearches) {
    state = state.copyWith(chefSearches: chefSearches);
  }

  void updateCarSearches(List<Ride>? carSearches) {
    state = state.copyWith(rideSearches: carSearches);
  }

  void setServiceType(ServiceType type) {
    state = state.copyWith(serviceType: type);
  }
}

final searchController =
    StateNotifierProvider<SearchFilterController, SearchUiState>(
        (ref) => SearchFilterController(locator.get(), ref));
