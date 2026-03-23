class LoginResponse {
  final String? accessToken;
  final String? chatToken;
  final bool? isEmailVerified;
  final dynamic user;

  LoginResponse({
    this.chatToken,
    this.accessToken,
    this.isEmailVerified,
    this.user,
  });

  LoginResponse copyWith({
    String? chatToken,
    String? accessToken,
    bool? isEmailVerified,
    dynamic user,
  }) =>
      LoginResponse(
        chatToken: chatToken ?? this.chatToken,
        accessToken: accessToken ?? this.accessToken,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        user: user ?? this.user,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"],
        chatToken: json["chatToken"],
        isEmailVerified: json["isEmailVerified"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "chatToken": chatToken,
        "access_token": accessToken,
        "isEmailVerified": isEmailVerified,
        "user": user,
      };
}
