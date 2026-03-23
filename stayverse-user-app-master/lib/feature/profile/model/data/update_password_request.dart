class UpdatePasswordRequest {
  final String? newPassword;
  final String? oldPassword;

  UpdatePasswordRequest({
    this.newPassword,
    this.oldPassword,
  });

  UpdatePasswordRequest copyWith({
    String? newPassword,
    String? oldPassword,
  }) =>
      UpdatePasswordRequest(
        newPassword: newPassword ?? this.newPassword,
        oldPassword: oldPassword ?? this.oldPassword,
      );

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordRequest(
        newPassword: json["newPassword"],
        oldPassword: json["oldPassword"],
      );

  Map<String, dynamic> toJson() => {
        "newPassword": newPassword,
        "oldPassword": oldPassword,
      };
}
