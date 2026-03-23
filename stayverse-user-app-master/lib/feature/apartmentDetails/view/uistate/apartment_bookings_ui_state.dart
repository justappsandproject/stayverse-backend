import 'package:flutter/material.dart';

class ApartmentBookingUiState {
  final bool isBusy;
  final double? apartmentPrice;

  final DateTimeRange? dateRange;

  const ApartmentBookingUiState({
    this.isBusy = false,
    this.apartmentPrice,
    this.dateRange,
  });

  ApartmentBookingUiState copyWith({
    bool? isBusy,
    DateTimeRange? dateRange,
    double? apartmentPrice,
  }) {
    return ApartmentBookingUiState(
      isBusy: isBusy ?? this.isBusy,
      apartmentPrice: apartmentPrice ?? this.apartmentPrice,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}
