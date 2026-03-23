class KycUiState {
  final bool isBusy;

  const KycUiState({
    this.isBusy = false,
  });

  KycUiState copyWith({
    bool? isBusy,
  }) {
    return KycUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
