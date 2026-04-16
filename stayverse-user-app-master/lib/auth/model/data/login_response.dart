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

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final rawUser = json["user"];
    CurrentUser? user;
    if (rawUser is Map) {
      user = CurrentUser.fromJson(Map<String, dynamic>.from(rawUser));
    }

    return LoginResponse(
      accessToken: json["access_token"]?.toString(),
      isEmailVerified: _readBool(json["isEmailVerified"]),
      user: user,
      chatToken: json['chatToken']?.toString(),
    );
  }

  static bool? _readBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().trim().toLowerCase();
    if (s == 'true') return true;
    if (s == 'false') return false;
    return null;
  }

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "isEmailVerified": isEmailVerified,
        "user": user?.toJson(),
        "chatToken": chatToken
      };
}
