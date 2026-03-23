class BookingStatusRequest {
  final String? bookingId;
  final BookingStatus? status;

  BookingStatusRequest({
    this.bookingId,
    this.status,
  });

  BookingStatusRequest copyWith({
    String? bookingId,
    BookingStatus? status,
  }) =>
      BookingStatusRequest(
        bookingId: bookingId ?? this.bookingId,
        status: status ?? this.status,
      );

  factory BookingStatusRequest.fromJson(Map<String, dynamic> json) =>
      BookingStatusRequest(
        bookingId: json["_id"],
        status: json["status"] != null 
            ? BookingStatus.fromString(json["status"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": bookingId,
        "status": status?.value,
      };
}


enum BookingStatus {
  pending('pending'),
  accepted('accepted'),
  completed('completed'),
  rejected('rejected');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus fromString(String status) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => BookingStatus.pending,
    );
  }
}