abstract class DashDataSource<T> {
  Future<T?> getUser();
  Future<T?> proposalAction({required String proposalId, required bool status});
  Future<T?> updateProfile(String firstName, String lastName);
}
