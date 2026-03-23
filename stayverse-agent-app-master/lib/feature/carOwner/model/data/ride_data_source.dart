import 'package:stayvers_agent/feature/carOwner/model/data/create_ride_request.dart';

abstract class RideDataSource<T> {
  Future<T?> createRide(CreateRideRequest request);
  Future<T?> editRide(String rideId, CreateRideRequest request);

}