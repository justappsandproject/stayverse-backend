class ChefProposalRequest {
  final double? price;
  final String? description;
  final DateTime? date;

  ChefProposalRequest({
    this.price,
    this.description,
    this.date,
  });

  ChefProposalRequest copyWith({
    double? price,
    String? description,
    DateTime? date,
  }) =>
      ChefProposalRequest(
        price: price ?? this.price,
        description: description ?? this.description,
        date: date ?? this.date,
      );

  factory ChefProposalRequest.fromJson(Map<String, dynamic> json) =>
      ChefProposalRequest(
        price: json["price"],
        description: json["description"],
        date: json["date"] == null
            ? null
            : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'description': description,
        'date': date?.toIso8601String(),
      };
}
