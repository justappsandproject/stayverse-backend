class Members {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final dynamic socketId;
  final dynamic lastSeenAt;
  final bool isOnline;

  Members({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.socketId,
    this.lastSeenAt,
    this.isOnline = false,
  });

  Members copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phoneNumber,
    dynamic socketId,
    dynamic lastSeenAt,
    bool? isOnline,
  }) =>
      Members(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        socketId: socketId ?? this.socketId,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        isOnline: isOnline ?? this.isOnline,
      );

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        socketId: json["socketId"],
        lastSeenAt: json["lastSeenAt"],
        isOnline: json["isOnline"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
        "socketId": socketId,
        "lastSeenAt": lastSeenAt,
        "isOnline": isOnline,
      };
}
