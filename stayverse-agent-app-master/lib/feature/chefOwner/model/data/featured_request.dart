import 'package:dio/dio.dart';

class FeaturedRequest {
  final List<MultipartFile>? featuredImage;
  final String? imageDescription;

  FeaturedRequest({
    this.featuredImage,
    this.imageDescription,
  });

  FeaturedRequest copyWith({
    List<MultipartFile>? featuredImage,
    String? imageDescription,
  }) =>
      FeaturedRequest(
        featuredImage: featuredImage ?? this.featuredImage,
        imageDescription: imageDescription ?? this.imageDescription,
      );
}

Future<FormData> buildFeaturedFormData(FeaturedRequest request) async {
  return FormData.fromMap({
    if (request.featuredImage != null && request.featuredImage!.isNotEmpty)
      'featuredImage': request.featuredImage,
    if (request.imageDescription != null)
      'imageDescription': request.imageDescription,
  });
}
