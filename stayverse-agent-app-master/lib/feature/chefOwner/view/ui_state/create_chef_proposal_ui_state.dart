class CreateProposalUiState {
  final bool? isBusy;

  CreateProposalUiState({
    this.isBusy = false,
  });

  CreateProposalUiState copyWith({
    bool? isBusy,
  }) {
    return CreateProposalUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}