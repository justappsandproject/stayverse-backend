class CertificationRequest {
  final String? title;
  final String? organization;
  final String? issuedDate;
  final String? certificateUrl;

  CertificationRequest({
    this.title,
    this.organization,
    this.issuedDate,
    this.certificateUrl,
  });

  CertificationRequest copyWith({
    String? title,
    String? organization,
    String? issuedDate,
    String? certificateUrl,
  }) =>
      CertificationRequest(
        title: title ?? this.title,
        organization: organization ?? this.organization,
        issuedDate: issuedDate ?? this.issuedDate,
        certificateUrl: certificateUrl ?? this.certificateUrl,
      );

  factory CertificationRequest.fromJson(Map<String, dynamic> json) =>
      CertificationRequest(
        title: json["title"],
        organization: json["organization"],
        issuedDate: json["issuedDate"],
        certificateUrl: json["certificateUrl"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "organization": organization,
        "issuedDate": issuedDate,
        "certificateUrl": certificateUrl,
      };
}
