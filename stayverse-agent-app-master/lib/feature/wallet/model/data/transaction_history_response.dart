import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';

class TransactionHistoryResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  TransactionHistoryResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  TransactionHistoryResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      TransactionHistoryResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  final List<Transactions>? data;
  final Pagination? pagination;

  Data({
    this.data,
    this.pagination,
  });

  Data copyWith({
    List<Transactions>? data,
    Pagination? pagination,
  }) =>
      Data(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Transactions>.from(
                json["data"]!.map((x) => Transactions.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}
class Transactions {
  final String? id;
  final String? reference;
  final double? amount;
  final TransactionType? type;
  final TransactionStatus? status;
  final String? userId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Transactions({
    this.id,
    this.reference,
    this.amount,
    this.type,
    this.status,
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Transactions copyWith({
    String? id,
    String? reference,
    double? amount,
    TransactionType? type,
    TransactionStatus? status,
    String? userId,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      Transactions(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        status: status ?? this.status,
        userId: userId ?? this.userId,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        id: json["_id"],
        reference: json["reference"],
        amount: json["amount"]?.toString().toDoubleOrNull(),
        type: TransactionType.fromString(json["type"]),
        status: TransactionStatus.fromString(json["status"]),
        userId: json["userId"],
        description: json["description"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "reference": reference,
        "amount": amount,
        "type": type?.id,
        "status": status?.id,
        "userId": userId,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Pagination {
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  Pagination copyWith({
    int? totalItems,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) =>
      Pagination(
        totalItems: totalItems ?? this.totalItems,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
        pageSize: pageSize ?? this.pageSize,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
      };
}
