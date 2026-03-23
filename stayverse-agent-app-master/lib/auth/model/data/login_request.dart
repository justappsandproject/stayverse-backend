

class LoginRequest {
    final String? email;
    final String? password;

    LoginRequest({
        this.email,
        this.password,
    });

    LoginRequest copyWith({
        String? email,
        String? password,
    }) => 
        LoginRequest(
            email: email ?? this.email,
            password: password ?? this.password,
        );

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
