class CreateApartmentUiState {
  final bool isBusy;

  CreateApartmentUiState({
    this.isBusy = false,
  });

  CreateApartmentUiState copyWith({
    bool? isBusy,
  }) {
    return CreateApartmentUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
