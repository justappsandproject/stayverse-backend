class RideBookingPaymentUiState {
  final bool isBusy;

  const RideBookingPaymentUiState({
    this.isBusy = false,
  });

  RideBookingPaymentUiState copyWith({
    bool? isBusy,
  }) {
    return RideBookingPaymentUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
