import 'package:equatable/equatable.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/read.dart';
import 'package:stayverse/core/service/brimChat/src/model/members.dart';

class ChatState implements Equatable {
  final String? id;
  final String? name;
  final String? image;
  final List<BrimMessage> messages;
  final List<Members> members;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, dynamic>? extraData;
  final List<Read> reads;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatState({
    this.id,
    this.name,
    this.image,
    this.lastMessage,
    this.lastMessageAt,
    this.extraData,
    this.messages = const [],
    this.members = const [],
    this.reads = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory ChatState.fromJson(Map<String, dynamic> json) {
    return ChatState(
      id: json['id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime'])
          : null,
      extraData: json['extraData'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((e) => BrimMessage.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      members: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => Members.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      reads: json['reads'] != null
          ? (json['reads'] as List)
              .map((e) => Read.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageAt?.toIso8601String(),
      'extraData': extraData,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'participants': members.map((e) => e.toJson()).toList(),
      'reads': reads.map((e) => e.toJson()).toList(),
    };
  }

  ChatState copyWith({
    String? id,
    String? name,
    String? image,
    List<BrimMessage>? messages,
    List<Members>? members,
    String? lastMessage,
    DateTime? lastMessageTime,
    Map<String, dynamic>? extraData,
    List<Read>? reads,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatState(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      messages: messages ?? this.messages,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageTime ?? lastMessageAt,
      extraData: extraData ?? this.extraData,
      reads: reads ?? this.reads,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        messages,
        members,
        lastMessage,
        lastMessageAt,
        extraData,
        reads,
        createdAt,
        updatedAt,
      ];

  @override
  bool? get stringify => true;
}
