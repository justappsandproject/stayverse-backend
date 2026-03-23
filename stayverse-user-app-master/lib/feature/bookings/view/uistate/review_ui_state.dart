import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayverse/feature/bookings/model/data/review_response.dart';

class ReviewUiState {
  
  const ReviewUiState({
    this.isBusy = false,
    this.isLoading = false,
    List<Review>? reviews,
    this.reviewPagination,
  }) : _reviews = reviews;

  final bool isBusy;
  final bool isLoading;

  final List<Review>? _reviews;

  FixedList<Review> get reviews => FixedList(_reviews ?? []);

  final ReviewPagination? reviewPagination;

  ReviewUiState copyWith({
    bool? isBusy,
    bool? isLoading,
    List<Review>? reviews,
    ReviewPagination? reviewPagination,
  }) {
    return ReviewUiState(
      isBusy: isBusy ?? this.isBusy,
      isLoading: isLoading ?? this.isLoading,
      reviews: reviews ?? _reviews,
      reviewPagination: reviewPagination ?? this.reviewPagination,
    );
  }
}
