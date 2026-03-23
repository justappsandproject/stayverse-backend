import 'package:dio/dio.dart';

class ChefProfileRequest {
  final String? fullName;
  final String? placeId;
  final String? bio;
  final String? about;
  final List<String>? culinarySpecialties;
  final double? pricingPerHour;
  final List<MultipartFile>? profilePicture;
  final List<MultipartFile>? coverPhoto;

  ChefProfileRequest({
    this.fullName,
    this.placeId,
    this.bio,
    this.about,
    this.culinarySpecialties,
    this.pricingPerHour,
    this.profilePicture,
    this.coverPhoto,
  });

  ChefProfileRequest copyWith({
    String? fullName,
    String? placeId,
    String? bio,
    String? about,
    List<String>? culinarySpecialties,
    double? pricingPerHour,
    List<MultipartFile>? profilePicture,
    List<MultipartFile>? coverPhoto,
  }) =>
      ChefProfileRequest(
        fullName: fullName ?? this.fullName,
        placeId: placeId ?? this.placeId,
        bio: bio ?? this.bio,
        about: about ?? this.about,
        culinarySpecialties: culinarySpecialties ?? this.culinarySpecialties,
        pricingPerHour: pricingPerHour ?? this.pricingPerHour,
        profilePicture: profilePicture ?? this.profilePicture,
        coverPhoto: coverPhoto ?? this.coverPhoto,
      );

}
Future<FormData> buildChefProfileFormData(ChefProfileRequest request) async {
  return FormData.fromMap({
    if (request.fullName != null) 'fullName': request.fullName,
    if (request.placeId != null) 'placeId': request.placeId,
    if (request.bio != null) 'bio': request.bio,
    if (request.about != null) 'about': request.about,
    if (request.culinarySpecialties != null)
      'culinarySpecialties': request.culinarySpecialties,
    if (request.pricingPerHour != null) 'pricingPerHour': request.pricingPerHour,
    if (request.profilePicture != null && request.profilePicture!.isNotEmpty)
      'profilePicture': request.profilePicture,
    if (request.coverPhoto != null && request.coverPhoto!.isNotEmpty)
      'coverPhoto': request.coverPhoto,
  });
}