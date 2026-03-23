class WithdrawalRequest {
  final String? fullName;
  final String? accountNumber;
  final String? bankCode;
  final double? amount;
  final String? password;

  WithdrawalRequest({
    this.fullName,
    this.accountNumber,
    this.bankCode,
    this.amount,
    this.password,
  });

  WithdrawalRequest copyWith({
    String? fullName,
    String? accountNumber,
    String? bankCode,
    double? amount,
    String? password,
  }) =>
      WithdrawalRequest(
        fullName: fullName ?? this.fullName,
        accountNumber: accountNumber ?? this.accountNumber,
        bankCode: bankCode ?? this.bankCode,
        amount: amount ?? this.amount,
        password: password ?? this.password,
      );

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) =>
      WithdrawalRequest(
        fullName: json["fullName"],

        accountNumber: json["accountNumber"],
        bankCode: json["bankCode"],
        amount: json["amount"],
        password: json["password"],
        
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "accountNumber": accountNumber,
        "bankCode": bankCode,
        "amount": amount,
        "password": password,
      };
}
