class ForgetPasswordUiState {
  final bool isBusy;

  ForgetPasswordUiState({
    this.isBusy = false,
  });

  ForgetPasswordUiState copyWith({
    bool? isBusy,
  }) {
    return ForgetPasswordUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
