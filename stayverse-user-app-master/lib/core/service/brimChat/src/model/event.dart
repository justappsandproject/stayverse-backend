import 'package:stayverse/core/service/brimChat/src/model/members.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';

class Event {
  final String? type;
  final String? data;
  final String? chatId;
  final BrimMessage? brimMessage;
  final Members? user;
  final DateTime createdAt;

  Event({
    required this.type,
    required this.data,
    DateTime? createdAt,
    this.chatId,
    this.brimMessage,
    this.user,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      user: json['user'] != null ? Members.fromJson(json['user']) : null,
      type: json['type'] as String?,
      data: json['data'],
      chatId: json['chatId'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      brimMessage: json['brimMessage'] != null
          ? BrimMessage.fromJson(json['brimMessage'])
          : null,
    );
  }
}
