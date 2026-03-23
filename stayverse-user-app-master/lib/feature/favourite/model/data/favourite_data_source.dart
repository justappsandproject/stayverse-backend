import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';

abstract class FavouriteDataSource<T> {
  Future<T?> getFavourites(ServiceType serviceType,{int? page,int? limit});
  Future<T?> addFavorite(FavouriteRequest favouriteRequest);
  Future<T?> removeFavorite(FavouriteRequest favouriteRequest);

}