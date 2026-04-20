class CuratedMessage {
  final String id;
  final String audience;
  final String title;
  final String body;
  final String? imageUrl;
  final String imagePosition;
  final bool viewed;
  final bool read;
  final String? reaction;
  final int viewedCount;
  final int readCount;
  final int likeCount;
  final int dislikeCount;
  final DateTime? createdAt;

  const CuratedMessage({
    required this.id,
    required this.audience,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.imagePosition,
    required this.viewed,
    required this.read,
    this.reaction,
    required this.viewedCount,
    required this.readCount,
    required this.likeCount,
    required this.dislikeCount,
    this.createdAt,
  });

  factory CuratedMessage.fromJson(Map<String, dynamic> json) {
    return CuratedMessage(
      id: (json['_id'] ?? '').toString(),
      audience: (json['audience'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      imagePosition: (json['imagePosition'] ?? 'after').toString(),
      viewed: (json['viewerState']?['viewed'] ?? false) == true,
      read: (json['viewerState']?['read'] ?? false) == true,
      reaction: json['viewerState']?['reaction']?.toString(),
      viewedCount: (json['metrics']?['viewedCount'] as num?)?.toInt() ?? 0,
      readCount: (json['metrics']?['readCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['metrics']?['likeCount'] as num?)?.toInt() ?? 0,
      dislikeCount: (json['metrics']?['dislikeCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
    );
  }
}
