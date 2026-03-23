class NotifyOfflineRequest {
  final String? recipientId;
  final String? senderName;
  final String? messagePreview;
  final String? chatLink;

  NotifyOfflineRequest({
    this.recipientId,
    this.senderName,
    this.messagePreview,
    this.chatLink,
  });

  NotifyOfflineRequest copyWith({
    String? recipientId,
    String? senderName,
    String? messagePreview,
    String? chatLink,
  }) =>
      NotifyOfflineRequest(
        recipientId: recipientId ?? this.recipientId,
        senderName: senderName ?? this.senderName,
        messagePreview: messagePreview ?? this.messagePreview,
        chatLink: chatLink ?? this.chatLink,
      );

  factory NotifyOfflineRequest.fromJson(Map<String, dynamic> json) =>
      NotifyOfflineRequest(
        recipientId: json['recipientId'],
        senderName: json['senderName'],
        messagePreview: json['messagePreview'],
        chatLink: json['chatLink'],
      );

  Map<String, dynamic> toJson() => {
        'recipientId': recipientId,
        'senderName': senderName,
        'messagePreview': messagePreview,
        'chatLink': chatLink,
      };
}