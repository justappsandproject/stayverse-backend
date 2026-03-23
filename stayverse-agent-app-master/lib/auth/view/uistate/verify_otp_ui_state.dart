class VerifyUiState {
  final bool isBusy;

  VerifyUiState({
    this.isBusy = false,
  });

  VerifyUiState copyWith({
    bool? isBusy,
  }) {
    return VerifyUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
