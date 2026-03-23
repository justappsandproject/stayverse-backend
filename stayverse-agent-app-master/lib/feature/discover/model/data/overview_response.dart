class OverviewResponse {
  final int? statusCode;
  final String? message;
  final OverviewData? data;
  final dynamic error;

  OverviewResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  OverviewResponse copyWith({
    int? statusCode,
    String? message,
    OverviewData? data,
    dynamic error,
  }) =>
      OverviewResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory OverviewResponse.fromJson(Map<String, dynamic> json) =>
      OverviewResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : OverviewData.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class OverviewData {
  final MetricCounts? bookings;
  final MetricCounts? request;
  final MetricCounts? favorites;
  final MetricCounts? earnings;

  OverviewData({
    this.bookings,
    this.request,
    this.favorites,
    this.earnings,
  });

  OverviewData copyWith({
    MetricCounts? bookings,
    MetricCounts? request,
    MetricCounts? favorites,
    MetricCounts? earnings,
  }) =>
      OverviewData(
        bookings: bookings ?? this.bookings,
        request: request ?? this.request,
        favorites: favorites ?? this.favorites,
        earnings: earnings ?? this.earnings,
      );

  factory OverviewData.fromJson(Map<String, dynamic> json) => OverviewData(
        bookings: json["bookings"] == null
            ? null
            : MetricCounts.fromJson(json["bookings"]),
        request: json["request"] == null
            ? null
            : MetricCounts.fromJson(json["request"]),
        favorites: json["favorites"] == null
            ? null
            : MetricCounts.fromJson(json["favorites"]),
        earnings: json["earnings"] == null
            ? null
            : MetricCounts.fromJson(json["earnings"]),
      );

  Map<String, dynamic> toJson() => {
        "bookings": bookings?.toJson(),
        "request": request?.toJson(),
        "favorites": favorites?.toJson(),
        "earnings": earnings?.toJson(),
      };
}

class MetricCounts {
  final int? week;
  final int? month;
  final int? year;

  MetricCounts({
    this.week,
    this.month,
    this.year,
  });

  MetricCounts copyWith({
    int? week,
    int? month,
    int? year,
  }) =>
      MetricCounts(
        week: week ?? this.week,
        month: month ?? this.month,
        year: year ?? this.year,
      );

  factory MetricCounts.fromJson(Map<String, dynamic> json) => MetricCounts(
        week: json["week"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "week": week,
        "month": month,
        "year": year,
      };
}
