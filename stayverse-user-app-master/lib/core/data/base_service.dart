import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';

/// Base Service for all service [Apartment, Chef, Ride]
abstract class BaseService {
  factory BaseService.fromJson(Map<String, dynamic> json, ServiceType type) {
    switch (type) {
      case ServiceType.apartment:
        return Apartment.fromJson(json);
      case ServiceType.chefs:
        return Chef.fromJson(json);
      case ServiceType.rides:
        return Ride.fromJson(json);
    }
  }
}
