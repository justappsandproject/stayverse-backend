class ProfileUiState {
  final bool isBusy;
  final bool isLoading;

  final bool isUpdatingNotification;

  const ProfileUiState({
    this.isBusy = false,
    this.isLoading = false,
    this.isUpdatingNotification = false,
  });

  ProfileUiState copyWith({
    bool? isBusy,
    bool? isLoading,
    bool? isUpdatingNotification,
  }) {
    return ProfileUiState(
      isUpdatingNotification:
          isUpdatingNotification ?? this.isUpdatingNotification,
      isBusy: isBusy ?? this.isBusy,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
