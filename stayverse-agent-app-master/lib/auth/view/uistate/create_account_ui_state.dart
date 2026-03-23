class CreateAccountUiState {
  final bool isBusy;

  CreateAccountUiState({
    this.isBusy = false,
  });

  CreateAccountUiState copyWith({
    bool? isBusy,
  }) {
    return CreateAccountUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
