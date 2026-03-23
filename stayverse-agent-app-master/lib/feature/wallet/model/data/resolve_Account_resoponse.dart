
class ResolveAccountResponse {
    final int? statusCode;
    final String? message;
    final Data? data;
    final dynamic error;

    ResolveAccountResponse({
        this.statusCode,
        this.message,
        this.data,
        this.error,
    });

    ResolveAccountResponse copyWith({
        int? statusCode,
        String? message,
        Data? data,
        dynamic error,
    }) => 
        ResolveAccountResponse(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
            error: error ?? this.error,
        );

    factory ResolveAccountResponse.fromJson(Map<String, dynamic> json) => ResolveAccountResponse(
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
    final String? accountNumber;
    final String? accountName;
    final int? bankId;

    Data({
        this.accountNumber,
        this.accountName,
        this.bankId,
    });

    Data copyWith({
        String? accountNumber,
        String? accountName,
        int? bankId,
    }) => 
        Data(
            accountNumber: accountNumber ?? this.accountNumber,
            accountName: accountName ?? this.accountName,
            bankId: bankId ?? this.bankId,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        bankId: json["bank_id"],
    );

    Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "account_name": accountName,
        "bank_id": bankId,
    };
}
