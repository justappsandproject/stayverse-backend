class ResetPasswordUiState {
  final bool isBusy;

  ResetPasswordUiState({
    this.isBusy = false,
  });

  ResetPasswordUiState copyWith({
    bool? isBusy,
  }) {
    return ResetPasswordUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
