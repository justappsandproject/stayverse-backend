class DeleteAccountUiState {
  final bool isBusy;  

  const DeleteAccountUiState({
    this.isBusy = false,
  });

  DeleteAccountUiState copyWith({
    bool? isBusy,
  }) {
    return DeleteAccountUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
