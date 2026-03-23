import 'package:dart_extensions/dart_extensions.dart';

class AddAReviewRequest {
  double? rating;
  String? review;

  AddAReviewRequest({
    this.rating,
    this.review,
  });

  AddAReviewRequest copyWith({
    double? rating,
    String? review,
  }) =>
      AddAReviewRequest(
        rating: rating ?? this.rating,
        review: review ?? this.review,
      );

  factory AddAReviewRequest.fromJson(Map<String, dynamic> json) {
    return AddAReviewRequest(
      rating: json['rating']?.toString().toDoubleOrNull(),
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review,
    };
  }
}
