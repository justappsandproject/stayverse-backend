
class VerifyBankRequest {
    final String? accountNumber;
    final String? bankCode;

    VerifyBankRequest({
        this.accountNumber,
        this.bankCode,
    });

    VerifyBankRequest copyWith({
        String? accountNumber,
        String? bankCode,
    }) => 
        VerifyBankRequest(
            accountNumber: accountNumber ?? this.accountNumber,
            bankCode: bankCode ?? this.bankCode,
        );

    factory VerifyBankRequest.fromJson(Map<String, dynamic> json) => VerifyBankRequest(
        accountNumber: json["account_number"],
        bankCode: json["bank_code"],
    );

    Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "bank_code": bankCode,
    };
}
