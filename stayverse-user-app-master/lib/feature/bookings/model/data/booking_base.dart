import 'package:stayverse/core/data/base_service.dart';

abstract class BookingBase {
  String? get imageUrl;
  String? get title;
  String? get description;
  double? get price;
  String? get address;
  BaseService? get service;
}
