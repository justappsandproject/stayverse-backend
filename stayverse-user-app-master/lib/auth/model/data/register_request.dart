class RegisterUserRequest {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final String? password;

  RegisterUserRequest({
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.password,
  });

  RegisterUserRequest copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? phoneNumber,
    String? password,
  }) =>
      RegisterUserRequest(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
      );

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) =>
      RegisterUserRequest(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
      };
}
