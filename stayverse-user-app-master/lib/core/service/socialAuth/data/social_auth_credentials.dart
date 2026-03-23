class SocialAuthCredential {
  final String provider; // 'google' or 'apple'
  final String idToken;
  final String? accessToken;
  final String? authorizationCode;
  final String? email;
  final String? firstName;
  final String? lastName;

  SocialAuthCredential({
    required this.provider,
    required this.idToken,
    this.accessToken,
    this.authorizationCode,
    this.email,
    this.firstName,
    this.lastName,
  });

  // Convert to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'id_token': idToken,
      if (accessToken != null) 'access_token': accessToken,
      if (authorizationCode != null) 'authorization_code': authorizationCode,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };
  }

  @override
  String toString() {
    return 'SocialAuthCredential(provider: $provider, email: $email)';
  }
}
