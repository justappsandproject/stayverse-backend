import 'package:dio/dio.dart';
import 'package:stayvers_agent/feature/profile/model/data/update_password_request.dart';

abstract class ProfileDataSource<T> {
  Future<T?> updatePassword(UpdatePasswordRequest updatePasswordRequest);
  Future<T?> getListedApartments(String status);
  Future<T?> getListedRides(String status);
  Future<T?> verifyKyc(String nin, MultipartFile selfie);
  Future<T?> uploadProfile(MultipartFile profilePicture);
}
