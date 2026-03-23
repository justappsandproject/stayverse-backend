class LoginUiState {
  final bool isBusy;

  LoginUiState({
    this.isBusy = false,
  });

  LoginUiState copyWith({
    bool? isBusy,
  }) {
    return LoginUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
