import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';

class ProposalResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  ProposalResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  ProposalResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      ProposalResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory ProposalResponse.fromJson(Map<String, dynamic> json) =>
      ProposalResponse(
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
  final String? message;
  final Proposal? proposal;

  Data({
    this.message,
    this.proposal,
  });

  Data copyWith({
    String? message,
    Proposal? proposal,
  }) =>
      Data(
        message: message ?? this.message,
        proposal: proposal ?? this.proposal,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        proposal: json["proposal"] == null
            ? null
            : Proposal.fromJson(json["proposal"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "proposal": proposal?.toJson(),
      };
}

class Proposal {
  final String? chefId;
  final String? userId;
  final double? price;
  final String? description;
  final ProposalStatus? status;
  final String? id;
  final DateTime? sentAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final ExtraDataType? extraDataType;
  final DateTime? proposalEndDate;

  Proposal({
    this.chefId,
    this.userId,
    this.price,
    this.description,
    this.status,
    this.id,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.extraDataType,
    this.proposalEndDate,
  });

  Proposal copyWith({
    String? chefId,
    String? userId,
    double? price,
    String? description,
    ProposalStatus? status,
    String? id,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    ExtraDataType? extraDataType,
    DateTime? proposalEndDate,
  }) =>
      Proposal(
        chefId: chefId ?? this.chefId,
        userId: userId ?? this.userId,
        price: price ?? this.price,
        description: description ?? this.description,
        status: status ?? this.status,
        id: id ?? this.id,
        sentAt: sentAt ?? this.sentAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        extraDataType: extraDataType ?? this.extraDataType,
        proposalEndDate: proposalEndDate ?? this.proposalEndDate,
      );

  factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
        chefId: json["chefId"],
        userId: json["userId"],
        price: json["price"]?.toString().toDoubleOrNull(),
        description: json["description"],
        status: ProposalStatus.fromString(json["status"]),
        id: json["_id"],
        sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        extraDataType: ExtraDataType.fromString(json["extraDataType"]),
        proposalEndDate: json["date"] == null
            ? DateTime.now()
            : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "extraDataType": ExtraDataType.proposal.id,
        "chefId": chefId,
        "userId": userId,
        "price": price,
        "description": description,
        "status": status?.id,
        "_id": id,
        "sentAt": sentAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "date": proposalEndDate?.toIso8601String(),
      };
}
