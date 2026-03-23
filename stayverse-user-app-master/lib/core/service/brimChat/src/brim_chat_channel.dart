import 'dart:async';

import 'package:stayverse/core/service/brimChat/brim_chat.dart';
import 'package:stayverse/core/service/brimChat/src/api/brim_chat_api.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/chat_state.dart';
import 'package:stayverse/core/service/brimChat/src/model/event.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/pagination.dart';
import 'package:stayverse/core/service/brimChat/src/socket/chat_socket.dart';
import 'package:synchronized/synchronized.dart';

class BrimChatChannel {
  String? _chatId;
  final Map<String, dynamic>? _extraData;

  BrimChatChannel(this._chatId, this._extraData);

  BrimChatChannel.fromState(ChatState state)
      : _chatId = state.id,
        _extraData = state.extraData {
    chatState = BrimChatChannelState(this, state);
    _initializedCompleter.complete(true);
  }

  //Check if the channel is initialized
  final Completer<bool> _initializedCompleter = Completer();

  ///The state of the chat
  BrimChatChannelState? chatState;

  void on(
    String eventType,
    void Function(Event event) callback,
  ) {
    ChatSocketIO.listen(eventType, (data) {
      final event = Event.fromJson(data);
      if (event.chatId == _chatId) {
        callback(event);
      }
    });
  }

  void off(Map<String, ChatEventHandler?> eventType) {
    ChatSocketIO.stopListeningToMany(eventType);
  }

  DateTime? get createdAt {
    return chatState?.chatState.createdAt;
  }

  Stream<DateTime?> get createdAtStream {
    return chatState!.chatStateStream.map((cs) => cs.createdAt);
  }

  DateTime? get updatedAt {
    return chatState?.chatState.updatedAt;
  }

  Stream<DateTime?> get updatedAtStream {
    return chatState!.chatStateStream.map((cs) => cs.updatedAt);
  }

  String? get cid => chatState?.chatState.id ?? _chatId;

  Map<String, Object?>? get extraData {
    var data = chatState?.chatState.extraData;
    if (data == null || data.isEmpty) {
      data = _extraData;
    }
    return data;
  }

  Stream<Map<String, Object?>?> get extraDataStream {
    return chatState!.chatStateStream.map(
      (cs) => cs.extraData ?? _extraData,
    );
  }

  Future<void> watch(
    Map<String, dynamic>? data,
  ) async {
    await queryChat(_chatId ?? '', data: data);
  }

  Future<void> queryChat(
    String chatId, {
    BrimPagination? pagination,
    Map<String, dynamic>? data,
  }) async {
    final chat = await BrimChatApi.queryChat(
      chatId,
      messagesPagination: pagination,
      data: data,
    );

    if (chat == null) {
      return;
    }

    _chatId ??= chat.id;

    if (chatState == null) {
      _initState(chat);
    } else {
      chatState?.updateChatState(chat);
    }

    return;
  }

  void _initState(ChatState chatState) {
    this.chatState = BrimChatChannelState(this, chatState);

    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete(true);
    }
  }

  // ignore: unused_field
  final _sendMessageLock = Lock();

  Future<BrimMessage?> sendMessage() async {
    return null;
  }

  Future<void> uploadAttachment() async {}

  Future<void> deleteMessage() async {}

  Future<void> cancleUpload(String attachmentId) async {}

  void updateAttachment(Attachment attachment, {bool remove = false}) {}

  void sendUploadProgress(int sent, int total) {}
}
