import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';

class BookingUiState {
  const BookingUiState({
    this.isBusy = false,
    this.error,
    this.isLoadingPending = false,
    this.isLoadingCompleted = false,
    this.isLoadingRejected = false,
    this.isLoadingAccepted = false,
    List<Booking>? pendingBookings,
    List<Booking>? completedBookings,
    List<Booking>? rejectedBookings,
    List<Booking>? acceptedBookings,

    this.pendingPagination,
    this.completedPagination,
    this.rejectedPagination,
    this.acceptedPagination,
  })  : _pendingBookings = pendingBookings,
        _completedBookings = completedBookings,
        _rejectedBookings = rejectedBookings,
        _acceptedBookings = acceptedBookings;

 final bool isBusy;
  final String? error;

  // Loading states

  final bool isLoadingPending;
  final bool isLoadingCompleted;
  final bool isLoadingRejected;
  final bool isLoadingAccepted;

    // Booking data

  final List<Booking>? _pendingBookings;
  final List<Booking>? _completedBookings;
  final List<Booking>? _rejectedBookings;
  final List<Booking>? _acceptedBookings;

  // Updated getters to use new Booking model
  FixedList<Booking> get pendingBookings => FixedList(_pendingBookings ?? []);
  FixedList<Booking> get completedBookings =>
      FixedList(_completedBookings ?? []);
  FixedList<Booking> get rejectedBookings => FixedList(_rejectedBookings ?? []);
  FixedList<Booking> get acceptedBookings => FixedList(_acceptedBookings ?? []);

  final Pagination? pendingPagination;
  final Pagination? completedPagination;
  final Pagination? rejectedPagination;
  final Pagination? acceptedPagination;

  BookingUiState copyWith({
    bool? isBusy,
    String? error,
    bool? isLoadingPending,
    bool? isLoadingCompleted,
    bool? isLoadingRejected,
    bool? isLoadingAccepted,
    List<Booking>? pendingBookings,
    List<Booking>? completedBookings,
    List<Booking>? rejectedBookings,
    List<Booking>? acceptedBookings,
    Pagination? pendingPagination,
    Pagination? completedPagination,
    Pagination? rejectedPagination,
    Pagination? acceptedPagination,
  }) {
    return BookingUiState(
       isBusy: isBusy ?? this.isBusy,
      error: error ?? this.error,
      isLoadingPending: isLoadingPending ?? this.isLoadingPending,
      isLoadingCompleted: isLoadingCompleted ?? this.isLoadingCompleted,
      isLoadingRejected: isLoadingRejected ?? this.isLoadingRejected,
      isLoadingAccepted: isLoadingAccepted ?? this.isLoadingAccepted,
      pendingBookings: pendingBookings ?? _pendingBookings,
      completedBookings: completedBookings ?? _completedBookings,
      rejectedBookings: rejectedBookings ?? _rejectedBookings,
      acceptedBookings: acceptedBookings ?? _acceptedBookings,
      pendingPagination: pendingPagination ?? this.pendingPagination,
      completedPagination: completedPagination ?? this.completedPagination,
      rejectedPagination: rejectedPagination ?? this.rejectedPagination,
      acceptedPagination: acceptedPagination ?? this.acceptedPagination,
    );
  }
}
