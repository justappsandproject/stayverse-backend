class ChefDetailsResponse {
  final int? statusCode;
  final String? message;
  final ChefDetailsData? data;
  final dynamic error;

  ChefDetailsResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  ChefDetailsResponse copyWith({
    int? statusCode,
    String? message,
    ChefDetailsData? data,
    dynamic error,
  }) {
    return ChefDetailsResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  factory ChefDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ChefDetailsResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] == null ? null : ChefDetailsData.fromJson(json['data']),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
        'error': error,
      };
}

class ChefDetailsData {
  final bool? hasProfile;
  final bool? hasExperience;
  final bool? hasCertifications;

  ChefDetailsData({
    this.hasProfile,
    this.hasExperience,
    this.hasCertifications,
  });

  ChefDetailsData copyWith({
    bool? hasProfile,
    bool? hasExperience,
    bool? hasCertifications,
  }) {
    return ChefDetailsData(
      hasProfile: hasProfile ?? this.hasProfile,
      hasExperience: hasExperience ?? this.hasExperience,
      hasCertifications: hasCertifications ?? this.hasCertifications,
    );
  }

  factory ChefDetailsData.fromJson(Map<String, dynamic> json) {
    return ChefDetailsData(
      hasProfile: json['hasProfile'],
      hasExperience: json['hasExperience'],
      hasCertifications: json['hasCertifications'],
    );
  }

  Map<String, dynamic> toJson() => {
        'hasProfile': hasProfile,
        'hasExperience': hasExperience,
        'hasCertifications': hasCertifications,
      };
}