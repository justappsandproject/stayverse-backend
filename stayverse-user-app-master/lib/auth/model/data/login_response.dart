import 'package:stayverse/core/data/current_user.dart';

class LoginResponse {
  final String? accessToken;
  final bool? isEmailVerified;
  final CurrentUser? user;
  final String? chatToken;

  LoginResponse(
      {this.accessToken, this.isEmailVerified, this.user, this.chatToken});

  LoginResponse copyWith(
          {String? accessToken,
          bool? isEmailVerified,
          CurrentUser? user,
          String? chatToken}) =>
      LoginResponse(
          accessToken: accessToken ?? this.accessToken,
          isEmailVerified: isEmailVerified ?? this.isEmailVerified,
          user: user ?? this.user,
          chatToken: chatToken ?? this.chatToken);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      accessToken: json["access_token"],
      isEmailVerified: json["isEmailVerified"],
      user: json["user"] == null ? null : CurrentUser.fromJson(json["user"]),
      chatToken: json['chatToken']);

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "isEmailVerified": isEmailVerified,
        "user": user?.toJson(),
        "chatToken": chatToken
      };
}
