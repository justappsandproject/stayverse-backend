import 'package:equatable/equatable.dart';
import 'members.dart'; // Make sure User has fromJson/toJson

class Read extends Equatable {
  const Read({
    required this.lastReadAt,
    required this.user,
    this.lastReadMessage,
    this.unreadMessages = 0,
  });

  /// Date of the read event
  final DateTime lastReadAt;

  /// User who sent the event
  final Members user;

  /// Number of unread messages
  final int unreadMessages;

  /// The id of the last read message
  final String? lastReadMessage;

  /// Create a new instance from a json
  factory Read.fromJson(Map<String, dynamic> json) {
    return Read(
      lastReadAt: DateTime.parse(json['lastRead'] as String),
      user: Members.fromJson(json['user'] as Map<String, dynamic>),
      lastReadMessage: json['lastReadMessage'] as String?,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
    );
  }

  /// Serialize to json
  Map<String, dynamic> toJson() {
    return {
      'lastRead': lastReadAt.toIso8601String(),
      'user': user.toJson(),
      'lastReadMessageId': lastReadMessage,
      'unreadMessages': unreadMessages,
    };
  }

  /// Creates a copy of [Read] with specified attributes overridden.
  Read copyWith({
    DateTime? lastReadAt,
    String? lastReadMessage,
    Members? user,
    int? unreadMessages,
  }) {
    return Read(
      lastReadAt: lastReadAt ?? this.lastReadAt,
      lastReadMessage: lastReadMessage ?? this.lastReadMessage,
      user: user ?? this.user,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }

  @override
  List<Object?> get props => [
        lastReadAt,
        lastReadMessage,
        user,
        unreadMessages,
      ];
}
