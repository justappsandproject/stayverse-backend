import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/shared/app_icons.dart';

class SearchBarData {
  final String title;
  final AppIcons icon;
  final ServiceType serviceType;

  const SearchBarData(this.title, this.icon,this.serviceType);

  factory SearchBarData.apartment() {
    return const SearchBarData(
      'Search Places',
      AppIcons.shortlet,
      ServiceType.apartment,
    );
  }

  factory SearchBarData.chefs() {
    return const SearchBarData(
      'Search Chefs',
      AppIcons.chef,
      ServiceType.chefs,
    );
  }

  factory SearchBarData.rides() {
    return const SearchBarData(
      'Search Rides',
      AppIcons.car,
      ServiceType.rides,
    );
  }

  factory SearchBarData.byIndex(int index) {
    switch (index) {
      case 0:
        return SearchBarData.apartment();
      case 1:
        return SearchBarData.rides();
      case 2:
        return SearchBarData.chefs();
      default:
        return SearchBarData.apartment();
    }
  }
}
