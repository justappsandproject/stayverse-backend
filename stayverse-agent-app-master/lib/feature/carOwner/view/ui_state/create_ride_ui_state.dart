class CreateRideUiState {
  final bool isBusy;

  CreateRideUiState({
    this.isBusy = false,
  });

  CreateRideUiState copyWith({
    bool? isBusy,
  }) {
    return CreateRideUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}