// ------------------- API Response Wrapper -------------------

class ReviewApiResponse {
  final int? statusCode;
  final String? message;
  final ReviewData? data;
  final dynamic error;

  ReviewApiResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  factory ReviewApiResponse.fromJson(Map<String, dynamic> json) {
    return ReviewApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? ReviewData.fromJson(json['data'])
          : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}


class ReviewData {
  final List<Review>? reviews;
  final ReviewPagination? pagination;

  ReviewData({
    this.reviews,
    this.pagination,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviews: json['data'] == null
          ? []
          : List<Review>.from(
              json['data'].map((x) => Review.fromJson(x)),
            ),
      pagination: json['pagination'] != null
          ? ReviewPagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "data": reviews?.map((x) => x.toJson()).toList() ?? [],
        "pagination": pagination?.toJson(),
      };
}


class Review {
  final String? id;
  final String? userId;
  final String? rideId;
  final int? v;
  final DateTime? createdAt;
  final double? rating;
  final String? review;
  final DateTime? updatedAt;
  final ReviewUser? user;

  Review({
    this.id,
    this.userId,
    this.rideId,
    this.v,
    this.createdAt,
    this.rating,
    this.review,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["_id"],
      userId: json["userId"],
      rideId: json["rideId"],
      v: json["__v"],
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      rating: (json["rating"] as num?)?.toDouble(),
      review: json["review"],
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
      user: json["user"] != null ? ReviewUser.fromJson(json["user"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "rideId": rideId,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "rating": rating,
        "review": review,
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class ReviewUser {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? profilePicture;

  String get fullName => '${firstname ?? ''} ${lastname ?? ''}'.trim();

  ReviewUser({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.profilePicture,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json["_id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      profilePicture: json["profilePicture"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "profilePicture": profilePicture,
      };
}


class ReviewPagination {
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  ReviewPagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory ReviewPagination.fromJson(Map<String, dynamic> json) {
    return ReviewPagination(
      totalItems: json["totalItems"],
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
      pageSize: json["pageSize"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPreviousPage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
      };
}
