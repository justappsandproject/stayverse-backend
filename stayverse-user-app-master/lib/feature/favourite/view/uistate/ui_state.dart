import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';

class FavouriteUiState {
  const FavouriteUiState({
    this.isLoadingChefFavourite = false,
    this.isLoadingApartmentFavourite = false,
    this.isLoadingRideFavourite = false,
    List<Apartment>? apartmentFavourite,
    List<Chef>? chefFavourite,
    List<Ride>? rideFavourite,
  })  : _apartmentFavourite = apartmentFavourite,
        _chefsFavourite = chefFavourite,
        _rideFavourite = rideFavourite;

  final List<Apartment>? _apartmentFavourite;
  final List<Chef>? _chefsFavourite;
  final List<Ride>? _rideFavourite;

  FixedList<Apartment> get apartmentsFavourites =>
      FixedList(_apartmentFavourite ?? []);

  FixedList<Chef> get chefFavourite => FixedList(_chefsFavourite ?? []);
  FixedList<Ride> get rideFavourite => FixedList(_rideFavourite ?? []);

  final bool isLoadingChefFavourite;
  final bool isLoadingApartmentFavourite;
  final bool isLoadingRideFavourite;

  FavouriteUiState copyWith({
    bool? isLoadingChefFavourite,
    bool? isLoadingApartmentFavourite,
    bool? isLoadingRideFavourite,
    List<Apartment>? apartmentFavourite,
    List<Chef>? chefFavourite,
    List<Ride>? rideFavourite,
  }) {
    return FavouriteUiState(
      apartmentFavourite: apartmentFavourite ?? _apartmentFavourite,
      chefFavourite: chefFavourite ?? _chefsFavourite,
      rideFavourite: rideFavourite ?? _rideFavourite,
      isLoadingChefFavourite:
          isLoadingChefFavourite ?? this.isLoadingChefFavourite,
      isLoadingApartmentFavourite:
          isLoadingApartmentFavourite ?? this.isLoadingApartmentFavourite,
      isLoadingRideFavourite:
          isLoadingRideFavourite ?? this.isLoadingRideFavourite,
    );
  }
}
