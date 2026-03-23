
class BookedDaysResponse {
    final int? statusCode;
    final String? message;
    final List<DateTime>? data;
    final dynamic error;

    BookedDaysResponse({
        this.statusCode,
        this.message,
        this.data,
        this.error,
    });

    BookedDaysResponse copyWith({
        int? statusCode,
        String? message,
        List<DateTime>? data,
        dynamic error,
    }) => 
        BookedDaysResponse(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
            error: error ?? this.error,
        );

    factory BookedDaysResponse.fromJson(Map<String, dynamic> json) => BookedDaysResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? [] : List<DateTime>.from(json["data"]!.map((x) => DateTime.parse(x))),
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toIso8601String())),
        "error": error,
    };
}
