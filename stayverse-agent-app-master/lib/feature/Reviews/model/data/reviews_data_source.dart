
abstract class ReviewsDataSource<T> {
  Future<T?> getReviews(String serviceType, String serviceId, {int? limit, int? page});
}
