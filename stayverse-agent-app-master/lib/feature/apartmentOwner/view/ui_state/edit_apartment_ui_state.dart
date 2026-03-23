class EditApartmentUiState {
  final bool isBusy;

  EditApartmentUiState({
    this.isBusy = false,
  });

  EditApartmentUiState copyWith({
    bool? isBusy,
  }) {
    return EditApartmentUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
