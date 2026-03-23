import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/apartmentDetails/view/uistate/apartment_bookings_ui_state.dart';

class ApartmentBookingsController
    extends StateNotifier<ApartmentBookingUiState> {
  ApartmentBookingsController() : super(const ApartmentBookingUiState());

  void updateBookingDates(DateTimeRange? dateRange, double pricePerNight) {
    if (!isDateRangeValid(dateRange)) {
      BrimToast.showError(
        'Please select a valid date range',
        title: 'Invalid Date Range',
      );
      return;
    }
    state = state.copyWith(dateRange: dateRange);
    calculateTotalPrice(pricePerNight);
  }

  void calculateTotalPrice(double pricePerNight) {
    if (state.dateRange == null) return;

    final start = state.dateRange!.start;
    final end = state.dateRange!.end;
    final totalNights = end.difference(start).inDays;

    if (totalNights <= 0) {
      return;
    }

    final apartmentPrice = totalNights * pricePerNight;
    state = state.copyWith(apartmentPrice: apartmentPrice);
  }

  bool isDateRangeValid(DateTimeRange? dateRange) {
    if (dateRange == null) return false;

    final today = DateTime.now();
    final start = DateTime(
        dateRange.start.year, dateRange.start.month, dateRange.start.day);
    final end =
        DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
    final current = DateTime(today.year, today.month, today.day);

    if (start.isBefore(current) || !end.isAfter(start)) return false;

    return true;
  }
}

final apartmentBookingsController = StateNotifierProvider.autoDispose<
    ApartmentBookingsController, ApartmentBookingUiState>(
  (ref) => ApartmentBookingsController(),
);
