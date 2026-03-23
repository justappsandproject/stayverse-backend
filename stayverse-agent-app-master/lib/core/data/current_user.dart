import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';

class CurrentUser {
  final KycVerificationStatus? kycStatus;
  final dynamic customerCode;
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final bool? isEmailVerified;
  final String? role;
  final dynamic socketId;
  final dynamic lastSeenAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? profilePicture;
  final Agent? agent;
  final double? balance;
  final bool? notificationsEnabled;

  String get fullName =>
      [firstname, lastname].where((e) => e != null).join(' ');

  String get initials => [firstname, lastname]
      .where((e) => e != null && e.isNotEmpty)
      .map((e) => e![0])
      .join();

  bool isMe(String? id) => this.id == id;

  bool get isVerified => kycStatus == KycVerificationStatus.approved;

  CurrentUser({
    this.profilePicture,
    this.kycStatus,
    this.customerCode,
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.isEmailVerified,
    this.role,
    this.socketId,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.agent,
    this.balance,
    this.notificationsEnabled,
  });

  CurrentUser copyWith({
    String? profilePicture,
    KycVerificationStatus? kycStatus,
    dynamic customerCode,
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phoneNumber,
    bool? isEmailVerified,
    String? role,
    dynamic socketId,
    dynamic lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Agent? agent,
    double? balance,
    bool? notificationsEnabled,
  }) =>
      CurrentUser(
        balance: balance ?? this.balance,
        profilePicture: profilePicture ?? this.profilePicture,
        kycStatus: kycStatus ?? this.kycStatus,
        customerCode: customerCode ?? this.customerCode,
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        role: role ?? this.role,
        socketId: socketId ?? this.socketId,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        agent: agent ?? this.agent,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        profilePicture: json['profilePicture'],
        balance: json["balance"]?.toString().toDoubleOrNull(),
        kycStatus: KycVerificationStatus.fromName(json["kycStatus"]),
        customerCode: json["customerCode"],
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        isEmailVerified: json["isEmailVerified"],
        role: json["role"],
        socketId: json["socketId"],
        lastSeenAt: json["lastSeenAt"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
        notificationsEnabled: json["notificationsEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "profilePicture": profilePicture,
        "kycStatus": kycStatus?.name,
        "customerCode": customerCode,
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "isEmailVerified": isEmailVerified,
        "role": role,
        "socketId": socketId,
        "lastSeenAt": lastSeenAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "agent": agent?.toJson(),
        "notificationsEnabled": notificationsEnabled,
      };
}

class Agent {
  final String? id;
  final int? balance;
  final ServiceType? serviceType;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? agentId;

  Agent({
    this.id,
    this.balance,
    this.serviceType,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.agentId,
  });

  Agent copyWith({
    String? id,
    int? balance,
    ServiceType? serviceType,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? agentId,
  }) =>
      Agent(
        id: id ?? this.id,
        balance: balance ?? this.balance,
        serviceType: serviceType ?? this.serviceType,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        agentId: agentId ?? this.agentId,
      );

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["_id"],
        balance: json["balance"],
        serviceType: ServiceType.fromString(json["serviceType"]),
        userId: json["userId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        agentId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "balance": balance,
        "serviceType": serviceType?.id,
        "userId": userId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "id": agentId,
      };
}

// class CurrentUser {
//   final String? id;
//   final String? firstname;
//   final String? lastname;
//   final String? email;
//   final String? phoneNumber;
//   final bool? isEmailVerified;
//   final bool? isPhoneNumberVerified;
//   final bool? hasSecurityPin;
//   final ServiceType? serviceType;
//   final String? agentId;

//   String get fullName =>
//       [firstname, lastname].where((e) => e != null).join(' ');

//   String get initials => [firstname, lastname]
//       .where((e) => e != null && e.isNotEmpty)
//       .map((e) => e![0])
//       .join();
//   final String? image;

//   bool isMe(String? id) => this.id == id;

//   CurrentUser({
//     this.id,
//     this.image,
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.phoneNumber,
//     this.isEmailVerified,
//     this.isPhoneNumberVerified,
//     this.hasSecurityPin,
//     this.serviceType,
//     this.agentId,
//   });

//   CurrentUser copyWith({
//     String? id,
//     String? firstname,
//     String? lastname,
//     String? email,
//     String? phoneNumber,
//     bool? isEmailVerified,
//     bool? isPhoneNumberVerified,
//     bool? hasSecurityPin,
//     ServiceType? serviceType,
//     String? agentId,
//   }) =>
//       CurrentUser(
//         id: id ?? this.id,
//         firstname: firstname ?? this.firstname,
//         lastname: lastname ?? this.lastname,
//         email: email ?? this.email,
//         phoneNumber: phoneNumber ?? this.phoneNumber,
//         isEmailVerified: isEmailVerified ?? this.isEmailVerified,
//         isPhoneNumberVerified:
//             isPhoneNumberVerified ?? this.isPhoneNumberVerified,
//         hasSecurityPin: hasSecurityPin ?? this.hasSecurityPin,
//         serviceType: serviceType ?? this.serviceType,
//         agentId: agentId ?? this.agentId,
//       );

//   factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
//         id: json["_id"],
//         firstname: json["firstname"],
//         lastname: json["lastname"],
//         email: json["email"],
//         phoneNumber: json["phoneNumber"],
//         isEmailVerified: json["isEmailVerified"],
//         isPhoneNumberVerified: json["isPhoneNumberVerified"],
//         hasSecurityPin: json["hasSecurityPin"],
//         serviceType: json["agent"] != null
//             ? ServiceType.fromString(json["agent"]["serviceType"])
//             : null,
//         agentId: json["agent"] != null ? json["agent"]["_id"] : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "firstname": firstname,
//         "lastname": lastname,
//         "email": email,
//         "phoneNumber": phoneNumber,
//         "isEmailVerified": isEmailVerified,
//         "isPhoneNumberVerified": isPhoneNumberVerified,
//         "hasSecurityPin": hasSecurityPin,
//         "serviceType": serviceType?.id,
//         "agentId": agentId,
//         "image": image
//       };
// }
