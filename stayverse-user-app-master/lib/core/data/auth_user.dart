import 'package:stayverse/core/data/current_user.dart';

class AuthUser {
  final String? accessToken;
  final bool? isPhoneNumberVerified;
  final CurrentUser? currentUser;

  AuthUser({
    this.accessToken,
    this.isPhoneNumberVerified,
    this.currentUser,
  });

  AuthUser copyWith({
    String? accessToken,
    bool? isPhoneNumberVerified,
    CurrentUser? currentUser,
  }) =>
      AuthUser(
        accessToken: accessToken ?? this.accessToken,
        isPhoneNumberVerified:
            isPhoneNumberVerified ?? this.isPhoneNumberVerified,
        currentUser: currentUser ?? this.currentUser,
      );

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        accessToken: json["access_token"],
        isPhoneNumberVerified: json["isPhoneNumberVerified"],
        currentUser:
            json["user"] == null ? null : CurrentUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "isPhoneNumberVerified": isPhoneNumberVerified,
        "user": currentUser?.toJson(),
      };
}
