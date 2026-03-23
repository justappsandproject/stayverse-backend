class RegisterUserRequest {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? serviceType;

  RegisterUserRequest({
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.password,
    this.serviceType,
  });

  RegisterUserRequest copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? phoneNumber,
    String? password,
    String? serviceType,
  }) =>
      RegisterUserRequest(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        serviceType: serviceType ?? this.serviceType,
      );

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) =>
      RegisterUserRequest(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        serviceType: json["serviceType"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "serviceType": serviceType,
      };
}
