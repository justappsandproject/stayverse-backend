import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/feature/search/model/data/car_search_filter.dart';
import 'package:stayverse/feature/search/model/data/chef_filter.dart';

abstract class SearchDataSource<T> {
  Future<T?> searchApartments(ApartmentSearchFilter filter);
  Future<T?> searchRides(CarSearchFilter filter);

  Future<T?> searchChef(ChefSearchFilter filter);
}
