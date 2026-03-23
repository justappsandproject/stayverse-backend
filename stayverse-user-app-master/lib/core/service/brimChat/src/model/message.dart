import 'package:equatable/equatable.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/message_state.dart';
import 'package:stayverse/core/service/brimChat/src/model/message_state_helper.dart';
import 'package:uuid/uuid.dart';

class BrimMessage extends Equatable {
  BrimMessage({
    String? messageId,
    this.id,
    this.sendAt,
    this.senderId,
    this.receiverId,
    this.chatId,
    this.content,
    this.attachments = const [],
    DateTime? createdAt,
    this.localCreatedAt,
    DateTime? updatedAt,
    this.localUpdatedAt,
    DateTime? deletedAt,
    this.localDeletedAt,
    this.state = MessageStates.inital,
  })  : trackingId = messageId ?? const Uuid().v4(),
        remoteCreatedAt = createdAt,
        remoteUpdatedAt = updatedAt,
        remoteDeletedAt = deletedAt;

  final String trackingId;
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? chatId;
  final String? content;
  final List<Attachment> attachments;
  final DateTime? remoteCreatedAt;
  final DateTime? localCreatedAt;
  final DateTime? remoteUpdatedAt;
  final DateTime? localUpdatedAt;
  final DateTime? remoteDeletedAt;
  final DateTime? localDeletedAt;

  final DateTime? sendAt;

  final MessageState? state;

  DateTime get createdAt => localCreatedAt ?? remoteCreatedAt ?? DateTime.now();

  DateTime get updatedAt => localUpdatedAt ?? remoteUpdatedAt ?? createdAt;

  DateTime? get deletedAt => localDeletedAt ?? remoteDeletedAt;

  BrimMessage copyWith({
    String? trackingId,
    String? id,
    String? senderId,
    String? receiverId,
    String? chatId,
    String? content,
    List<Attachment>? attachments,
    DateTime? remoteCreatedAt,
    DateTime? localCreatedAt,
    DateTime? remoteUpdatedAt,
    DateTime? localUpdatedAt,
    DateTime? remoteDeletedAt,
    DateTime? localDeletedAt,
    MessageState? state,
  }) {
    return BrimMessage(
      messageId: trackingId ?? this.trackingId,
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      localCreatedAt: localCreatedAt ?? this.localCreatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      localDeletedAt: localDeletedAt ?? this.localDeletedAt,
      state: state ?? this.state,
    );
  }

  BrimMessage merge(BrimMessage otherMessage) {
    return copyWith(
      id: otherMessage.id,
      senderId: otherMessage.senderId,
      receiverId: otherMessage.receiverId,
      chatId: otherMessage.chatId,
      content: otherMessage.content,
      attachments: otherMessage.attachments,
      remoteCreatedAt: otherMessage.remoteCreatedAt,
      localCreatedAt: otherMessage.localCreatedAt,
      remoteUpdatedAt: otherMessage.remoteUpdatedAt,
      localUpdatedAt: otherMessage.localUpdatedAt,
      remoteDeletedAt: otherMessage.remoteDeletedAt,
      localDeletedAt: otherMessage.localDeletedAt,
      state: otherMessage.state,
    );
  }

  BrimMessage syncWith(BrimMessage? otherMessage) {
    if (otherMessage == null) return this;
    return copyWith(
      localCreatedAt: otherMessage.localCreatedAt,
      localUpdatedAt: otherMessage.localUpdatedAt,
      localDeletedAt: otherMessage.localDeletedAt,
    );
  }

  factory BrimMessage.fromJson(Map<String, dynamic> json) {
    final message = BrimMessage(
      messageId: json['messageId'] as String?,
      id: json['id'] as String?,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      chatId: json['chatId'] as String?,
      content: json['content'] as String?,
      sendAt: json['sentAt'] != null ? DateTime.tryParse(json['sentAt']) : null,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['remoteCreatedAt'] != null
          ? DateTime.tryParse(json['remoteCreatedAt'])
          : null,
      updatedAt: json['remoteUpdatedAt'] != null
          ? DateTime.tryParse(json['remoteUpdatedAt'])
          : null,
      deletedAt: json['remoteDeletedAt'] != null
          ? DateTime.tryParse(json['remoteDeletedAt'])
          : null,
    );

    var state = MessageStates.sent;
    if (message.deletedAt != null) {
      state = MessageStates.softDeleted;
    } else if (message.updatedAt.isAfter(message.createdAt)) {
      state = MessageStates.updated;
    }
    return message.copyWith(state: state);
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{
      'trackingId': trackingId,
      'content': content,
      'sentAt': DateTime.now().toIso8601String(),
    };

    if (attachments.isNotEmpty) {
      val['attachments'] = attachments.map((e) => e.toJson()).toList();
    }

    return val;
  }

  @override
  List<Object?> get props => [
        trackingId,
        id,
        senderId,
        receiverId,
        chatId,
        content,
        attachments,
        remoteCreatedAt,
        localCreatedAt,
        remoteUpdatedAt,
        localUpdatedAt,
        remoteDeletedAt,
        localDeletedAt,
        state,
      ];
}
