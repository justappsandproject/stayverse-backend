class CuratedMessage {
  final String id;
  final String audience;
  final String title;
  final String body;
  final DateTime? createdAt;

  const CuratedMessage({
    required this.id,
    required this.audience,
    required this.title,
    required this.body,
    this.createdAt,
  });

  factory CuratedMessage.fromJson(Map<String, dynamic> json) {
    return CuratedMessage(
      id: (json['_id'] ?? '').toString(),
      audience: (json['audience'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
    );
  }
}
