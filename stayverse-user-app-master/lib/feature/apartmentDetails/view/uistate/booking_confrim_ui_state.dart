class BookingPaymentUiState {
  final bool isBusy;

  const BookingPaymentUiState({
    this.isBusy = false,
  });

  BookingPaymentUiState copyWith({
    bool? isBusy,
  }) {
    return BookingPaymentUiState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
