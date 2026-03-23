class BanksResponse {
  final int? statusCode;
  final String? message;
  final List<Bank>? data;
  final dynamic error;

  BanksResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  BanksResponse copyWith({
    int? statusCode,
    String? message,
    List<Bank>? data,
    dynamic error,
  }) =>
      BanksResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory BanksResponse.fromJson(Map<String, dynamic> json) => BanksResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Bank>.from(json["data"]!.map((x) => Bank.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "error": error,
      };
}

class Bank {
  final int? id;
  final String? name;
  final String? slug;
  final String? code;
  final String? longcode;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bank({
    this.id,
    this.name,
    this.slug,
    this.code,
    this.longcode,
    this.createdAt,
    this.updatedAt,
  });

  Bank copyWith({
    int? id,
    String? name,
    String? slug,
    String? code,
    String? longcode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Bank(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        code: code ?? this.code,
        longcode: longcode ?? this.longcode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        code: json["code"],
        longcode: json["longcode"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "code": code,
        "longcode": longcode,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
