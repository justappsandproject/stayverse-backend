import 'package:dio/dio.dart';
import 'package:stayverse/feature/profile/model/data/update_password_request.dart';

abstract class ProfileDataSource<T> {
  Future<T?> updatePassword(UpdatePasswordRequest updatePasswordRequest);
  Future<T?> verifyKyc(String nin, MultipartFile selfie);
  Future<T?> uploadProfile(MultipartFile profilePicture);
  Future<T?> deleteAccount(String password);
}
