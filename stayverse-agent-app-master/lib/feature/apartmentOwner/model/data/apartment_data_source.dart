import 'package:stayvers_agent/feature/apartmentOwner/model/data/create_apartment_request.dart';

abstract class ApartmentDataSource<T> {
  Future<T?> createApartment(CreateApartmentRequest request);
  Future<T?> editApartment(String apartmentId, CreateApartmentRequest request);

}
