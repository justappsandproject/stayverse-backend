abstract class DashboardDataSource<T> {
  Future<T?> getUser();
  Future<T?> updateProfile(String firstName, String lastName);
}
