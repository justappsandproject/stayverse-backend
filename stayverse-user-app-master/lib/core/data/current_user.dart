import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/data/enum/enums.dart';

class CurrentUser {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final bool? isEmailVerified;
  final Roles? roles;
  final bool? notificationsEnabled;
  final String? profilePicture;
  final double? balance;
  final KycVerificationStatus? kycStatus;

  String get fullName =>
      [firstname, lastname].where((e) => e != null).join(' ');

  String get initials => [firstname, lastname]
      .where((e) => e != null && e.isNotEmpty)
      .map((e) => e![0])
      .join();

  bool isMe(String? id) => this.id == id;

  bool get isVerified => kycStatus == KycVerificationStatus.approved;

  CurrentUser({
    this.id,
    this.firstname,
    this.lastname,
    this.profilePicture,
    this.email,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.roles = Roles.user,
    this.notificationsEnabled = true,
    this.balance,
    this.kycStatus,
  });

  CurrentUser copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? profilePicture,
    String? email,
    String? phoneNumber,
    bool? isEmailVerified,
    Roles? roles,
    double? balance,
    bool? notificationsEnabled,
    KycVerificationStatus? kycStatus,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      roles: roles ?? this.roles,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      balance: balance ?? this.balance,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    final roleRaw = json['role'] ?? json['roles'];
    final parsedRole = Roles.tryParse(roleRaw);

    return CurrentUser(
      id: _parseId(json['_id'] ?? json['id']),
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      notificationsEnabled: _readBool(json['notificationsEnabled']),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      isEmailVerified: _readBool(json['isEmailVerified']) ?? false,
      profilePicture: json['profilePicture']?.toString(),
      balance: json["balance"]?.toString().toDoubleOrNull(),
      kycStatus: KycVerificationStatus.fromName(json["kycStatus"]?.toString()),
      roles: parsedRole ?? Roles.user,
    );
  }

  static String? _parseId(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final oid = value[r'$oid'];
      if (oid != null) return oid.toString();
    }
    return value.toString();
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'notificationsEnabled': notificationsEnabled,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'roles': roles?.name,
      'profilePicture': profilePicture,
      'balance': balance,
      "kycStatus": kycStatus?.name,
    };
  }

  @override
  String toString() {
    return 'CurrentUser(id: $id, firstname: $firstname, lastname: $lastname, email: $email, profilePicture: $profilePicture, phoneNumber: $phoneNumber, isEmailVerified: $isEmailVerified, roles: $roles)';
  }
}
