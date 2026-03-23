class ProposalUiState {
  final bool? isBusy;
  final String? currentProposalId;

  ProposalUiState({
    this.isBusy = false,
    this.currentProposalId,
  });

  ProposalUiState copyWith({
    bool? isBusy,
    String? currentProposalId,
  }) {
    return ProposalUiState(
      isBusy: isBusy ?? this.isBusy,
      currentProposalId: currentProposalId ?? this.currentProposalId,
    );
  }

  ProposalUiState resetCurrentProposalId() {
    return ProposalUiState(currentProposalId: null, isBusy: false);
  }
}
