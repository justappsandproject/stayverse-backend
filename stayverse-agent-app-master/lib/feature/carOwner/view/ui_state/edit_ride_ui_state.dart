class EditRideUiState {
  final bool isBusy;

  EditRideUiState({
    this.isBusy = false,
  });

  EditRideUiState copyWith({
    bool? isBusy,
  }) {
    return EditRideUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}