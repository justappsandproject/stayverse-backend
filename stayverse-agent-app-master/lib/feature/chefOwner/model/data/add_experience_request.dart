class ExperienceRequest {
  final String? title;
  final String? company;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? placeId;
  final String? address;
  final bool? stayVerseJob;

  ExperienceRequest({
    this.title,
    this.company,
    this.description,
    this.startDate,
    this.endDate,
    this.placeId,
    this.address,
    this.stayVerseJob,
  });

  ExperienceRequest copyWith({
    String? title,
    String? company,
    String? description,
    String? startDate,
    String? endDate,
    String? placeId,
    String? address,
    bool? stayVerseJob,
  }) =>
      ExperienceRequest(
        title: title ?? this.title,
        company: company ?? this.company,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        placeId: placeId ?? this.placeId,
        address: address ?? this.address,
        stayVerseJob: stayVerseJob ?? this.stayVerseJob,
      );

  factory ExperienceRequest.fromJson(Map<String, dynamic> json) =>
      ExperienceRequest(
        title: json["title"],
        company: json["company"],
        description: json["description"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        placeId: json["placeId"],
        address: json["address"],
        stayVerseJob: json["stayVerseJob"],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'placeId': placeId,
        'address': address,
        'stayVerseJob': stayVerseJob,
      };
}
