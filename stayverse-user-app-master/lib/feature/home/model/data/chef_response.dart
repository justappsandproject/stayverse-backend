import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/data/base_service.dart';
import 'package:stayverse/core/data/service_location.dart';

class ChefResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  ChefResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  ChefResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      ChefResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory ChefResponse.fromJson(Map<String, dynamic> json) => ChefResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  final List<Chef>? chefs;
  final Pagination? pagination;

  Data({
    this.chefs,
    this.pagination,
  });

  Data copyWith({
    List<Chef>? chefs,
    Pagination? pagination,
  }) =>
      Data(
        chefs: chefs ?? this.chefs,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        chefs: json["chefs"] == null
            ? []
            : List<Chef>.from(json["chefs"]!.map((x) => Chef.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "chefs": chefs == null
            ? []
            : List<dynamic>.from(chefs!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Chef implements BaseService {
  final String? id;
  final String? agentId;
  final String? fullName;
  final String? address;
  final String? placeId;
  final ServiceLocation? location;
  final String? bio;
  final String? about;
  final List<String>? culinarySpecialties;
  final double? pricingPerHour;
  final String? profilePicture;
  final String? bookedStatus;
  final String? status;
  final String? coverPhoto;
  final bool? hasExperience;
  final bool? hasCertifications;
  final double? averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? distance;
  final Agent? agent;
  final bool? isFavorite;
  final List<Feature>? features;
  final List<Experience>? experiences;
  final List<Certification>? certifications;

  Chef(
      {this.id,
      this.agentId,
      this.fullName,
      this.address,
      this.placeId,
      this.location,
      this.bio,
      this.about,
      this.culinarySpecialties,
      this.pricingPerHour,
      this.profilePicture,
      this.bookedStatus,
      this.status,
      this.coverPhoto,
      this.hasExperience,
      this.hasCertifications,
      this.averageRating,
      this.createdAt,
      this.updatedAt,
      this.distance,
      this.agent,
      this.isFavorite,
      this.features,
      this.experiences,
      this.certifications,
      });

  Chef copyWith(
          {String? id,
          String? agentId,
          String? fullName,
          String? address,
          String? placeId,
          ServiceLocation? location,
          String? bio,
          String? about,
          List<String>? culinarySpecialties,
          double? pricingPerHour,
          String? profilePicture,
          String? bookedStatus,
          String? status,
          String? coverPhoto,
          bool? hasExperience,
          bool? hasCertifications,
          double? averageRating,
          DateTime? createdAt,
          DateTime? updatedAt,
          double? distance,
          Agent? agent,
          bool? isFavorite,
          List<Feature>? features,
          List<Experience>? experiences,
          List<Certification>? certifications,
          }) =>
      Chef(
          id: id ?? this.id,
          agentId: agentId ?? this.agentId,
          fullName: fullName ?? this.fullName,
          address: address ?? this.address,
          placeId: placeId ?? this.placeId,
          location: location ?? this.location,
          bio: bio ?? this.bio,
          about: about ?? this.about,
          culinarySpecialties: culinarySpecialties ?? this.culinarySpecialties,
          pricingPerHour: pricingPerHour ?? this.pricingPerHour,
          profilePicture: profilePicture ?? this.profilePicture,
          bookedStatus: bookedStatus ?? this.bookedStatus,
          status: status ?? this.status,
          coverPhoto: coverPhoto ?? this.coverPhoto,
          hasExperience: hasExperience ?? this.hasExperience,
          hasCertifications: hasCertifications ?? this.hasCertifications,
          averageRating: averageRating ?? this.averageRating,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          distance: distance ?? this.distance,
          agent: agent ?? this.agent,
          isFavorite: isFavorite ?? this.isFavorite,
          features: features ?? this.features,
          experiences: experiences ?? this.experiences,
          certifications: certifications ?? this.certifications,
          );

  factory Chef.fromJson(Map<String, dynamic> json) => Chef(
      id: json["_id"],
      agentId: json["agentId"],
      fullName: json["fullName"],
      address: json["address"],
      placeId: json["placeId"],
      location: json["location"] == null
          ? null
          : ServiceLocation.fromJson(json["location"]),
      bio: json["bio"],
      about: json["about"],
      culinarySpecialties: json["culinarySpecialties"] == null
          ? []
          : List<String>.from(json["culinarySpecialties"]!.map((x) => x)),
      pricingPerHour: json["pricingPerHour"]?.toString().toDoubleOrNull(),
      profilePicture: json["profilePicture"],
      bookedStatus: json["bookedStatus"],
      status: json["status"],
      coverPhoto: json["coverPhoto"],
      hasExperience: json["hasExperience"],
      hasCertifications: json["hasCertifications"],
      averageRating: json["averageRating"]?.toString().toDoubleOrNull(),
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      distance: json["distance"]?.toDouble(),
      agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
      isFavorite: json["isFavorite"],
       features: (json['features'] as List<dynamic>?) // Updated parsing
              ?.map((e) => Feature.fromJson(e))
              .toList() ??
          [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e))
              .toList() ??
          [],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "agentId": agentId,
        "fullName": fullName,
        "address": address,
        "placeId": placeId,
        "location": location?.toJson(),
        "bio": bio,
        "about": about,
        "culinarySpecialties": culinarySpecialties == null
            ? []
            : List<dynamic>.from(culinarySpecialties!.map((x) => x)),
        "pricingPerHour": pricingPerHour,
        "profilePicture": profilePicture,
        "bookedStatus": bookedStatus,
        "status": status,
        "coverPhoto": coverPhoto,
        "hasExperience": hasExperience,
        "hasCertifications": hasCertifications,
        "averageRating": averageRating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "distance": distance,
        "agent": agent?.toJson(),
        "isFavorite": isFavorite,
        'features': features?.map((e) => e.toJson()).toList(),
        'experiences': experiences?.map((e) => e.toJson()).toList(),
        'certifications': certifications?.map((e) => e.toJson()).toList(),
      };
}

class Agent {
  final String? id;
  final String? serviceType;
  final String? userId;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;

  Agent({
    this.id,
    this.serviceType,
    this.userId,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
  });

  Agent copyWith({
    String? id,
    String? serviceType,
    String? userId,
    String? firstname,
    String? lastname,
    String? email,
    String? phoneNumber,
  }) =>
      Agent(
        id: id ?? this.id,
        serviceType: serviceType ?? this.serviceType,
        userId: userId ?? this.userId,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["_id"],
        serviceType: json["serviceType"],
        userId: json["userId"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceType": serviceType,
        "userId": userId,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}

class Pagination {
  final int? total;
  final int? totalPages;
  final int? currentPage;

  Pagination({
    this.total,
    this.totalPages,
    this.currentPage,
  });

  Pagination copyWith({
    int? total,
    int? totalPages,
    int? currentPage,
  }) =>
      Pagination(
        total: total ?? this.total,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}

class Feature {
  final String? id;
  final String? chefId;
  final int? v;
  final String? createdAt;
  final List<FeaturedImage>? featuredImages;
  final String? updatedAt;

  Feature({
    this.id,
    this.chefId,
    this.v,
    this.createdAt,
    this.featuredImages,
    this.updatedAt,
  });

  Feature copyWith({
    String? id,
    String? chefId,
    int? v,
    String? createdAt,
    List<FeaturedImage>? featuredImages,
    String? updatedAt,
  }) {
    return Feature(
      id: id ?? this.id,
      chefId: chefId ?? this.chefId,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      featuredImages: featuredImages ?? this.featuredImages,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['_id'],
      chefId: json['chefId'],
      v: json['__v'],
      createdAt: json['createdAt'],
      featuredImages: (json['featuredImages'] as List<dynamic>?)
              ?.map((e) => FeaturedImage.fromJson(e))
              .toList() ??
          [],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chefId': chefId,
        '__v': v,
        'createdAt': createdAt,
        'featuredImages': featuredImages?.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt,
      };
}

class FeaturedImage {
  final String? imageUrl;
  final String? description;

  FeaturedImage({
    this.imageUrl,
    this.description,
  });

  FeaturedImage copyWith({
    String? imageUrl,
    String? description,
  }) {
    return FeaturedImage(
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  factory FeaturedImage.fromJson(Map<String, dynamic> json) {
    return FeaturedImage(
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'description': description,
      };
}

class Experience {
  final String? id;
  final String? chefId;
  final String? title;
  final String? company;
  final String? description;
  final String? startDate;
  final String? endDate;
  final bool? stillWorking;
  final String? placeId;
  final String? address;
  final bool? stayVerseJob;
  final String? createdAt;
  final String? updatedAt;

  Experience({
    this.id,
    this.chefId,
    this.title,
    this.company,
    this.description,
    this.startDate,
    this.endDate,
    this.stillWorking,
    this.placeId,
    this.address,
    this.stayVerseJob,
    this.createdAt,
    this.updatedAt,
  });

  Experience copyWith({
    String? id,
    String? chefId,
    String? title,
    String? company,
    String? description,
    String? startDate,
    String? endDate,
    bool? stillWorking,
    String? placeId,
    String? address,
    bool? stayVerseJob,
    String? createdAt,
    String? updatedAt,
  }) =>
      Experience(
        id: id ?? this.id,
        chefId: chefId ?? this.chefId,
        title: title ?? this.title,
        company: company ?? this.company,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        stillWorking: stillWorking ?? this.stillWorking,
        placeId: placeId ?? this.placeId,
        address: address ?? this.address,
        stayVerseJob: stayVerseJob ?? this.stayVerseJob,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        id: json['_id'],
        chefId: json['chefId'],
        title: json['title'],
        company: json['company'],
        description: json['description'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        stillWorking: json['stillWorking'],
        placeId: json['placeId'],
        address: json['address'],
        stayVerseJob: json['stayVerseJob'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chefId': chefId,
        'title': title,
        'company': company,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'stillWorking': stillWorking,
        'placeId': placeId,
        'address': address,
        'stayVerseJob': stayVerseJob,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class Certification {
  final String? id;
  final String? chefId;
  final String? title;
  final String? organization;
  final String? issuedDate;
  final String? certificateUrl;
  final String? createdAt;
  final String? updatedAt;

  Certification({
    this.id,
    this.chefId,
    this.title,
    this.organization,
    this.issuedDate,
    this.certificateUrl,
    this.createdAt,
    this.updatedAt,
  });

  Certification copyWith({
    String? id,
    String? chefId,
    String? title,
    String? organization,
    String? issuedDate,
    String? certificateUrl,
    String? createdAt,
    String? updatedAt,
  }) =>
      Certification(
        id: id ?? this.id,
        chefId: chefId ?? this.chefId,
        title: title ?? this.title,
        organization: organization ?? this.organization,
        issuedDate: issuedDate ?? this.issuedDate,
        certificateUrl: certificateUrl ?? this.certificateUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
        id: json['_id'],
        chefId: json['chefId'],
        title: json['title'],
        organization: json['organization'],
        issuedDate: json['issuedDate'],
        certificateUrl: json['certificateUrl'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chefId': chefId,
        'title': title,
        'organization': organization,
        'issuedDate': issuedDate,
        'certificateUrl': certificateUrl,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

