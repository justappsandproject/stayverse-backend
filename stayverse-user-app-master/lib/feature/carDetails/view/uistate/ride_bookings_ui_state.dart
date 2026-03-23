import 'package:flutter/material.dart';

class RideBookingUiState {
  final bool isBusy;
  final double? ridePrice;

  final DateTimeRange? dateRange;

  const RideBookingUiState({
    this.isBusy = false,
    this.ridePrice,
    this.dateRange,
  });

  RideBookingUiState copyWith({
    bool? isBusy,
    DateTimeRange? dateRange,
    double? ridePrice,
  }) {
    return RideBookingUiState(
      isBusy: isBusy ?? this.isBusy,
      ridePrice: ridePrice ?? this.ridePrice,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}
