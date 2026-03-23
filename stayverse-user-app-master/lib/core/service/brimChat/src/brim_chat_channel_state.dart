import 'package:dart_extensions/dart_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/brimChat/src/model/chat_state.dart';
import 'package:stayverse/core/service/brimChat/src/model/event.dart';
import 'package:stayverse/core/service/brimChat/src/model/event_type.dart';
import 'package:stayverse/core/service/brimChat/src/model/members.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/read.dart';
import 'package:stayverse/core/service/brimChat/src/socket/chat_socket.dart';

import '../brim_chat.dart';

class BrimChatChannelState {
  final BrimChatChannel _brimChannel;

  BrimChatChannelState(this._brimChannel, ChatState chatState) {
    _chatStateController = BehaviorSubject<ChatState>.seeded(chatState);
    _listenToNewMessage();
    _listenMessageDeleted();
    _listenToRead();
    _listenToTyping();
    _startCleaningStaleTypingEvents();
  }

  late BehaviorSubject<ChatState> _chatStateController;

  final Map<String, ChatEventHandler?> _eventListeners = {};

  ChatState get chatState => _chatStateController.value;

  Stream<ChatState> get chatStateStream => _chatStateController.stream;

  List<BrimMessage> get messages => chatState.messages;

  List<Read> get read => chatState.reads;

  /// Channel read list as a stream.
  Stream<List<Read>> get readStream => chatStateStream.map((cs) => cs.reads);

  /// Channel read for the logged in user.
  Read? get currentUserRead => read.firstOrNullWhere(_isCurrentUserReads);

  /// Channel read for the logged in user as a stream.
  Stream<Read?> get currentUserReadStream =>
      readStream.map((read) => read.firstOrNullWhere(_isCurrentUserReads));

  /// Unread count getter as a stream.
  Stream<int> get unreadCountStream =>
      currentUserReadStream.map((read) => read?.unreadMessages ?? 0);

  /// Unread count getter.
  int get unreadCount => currentUserRead?.unreadMessages ?? 0;

  set chatState(ChatState chatState) {
    _chatStateController.add(chatState);
  }

  void updateChatState(ChatState updatedState) {
    final existingStateMessages = [...messages];
    final newMessages = <BrimMessage>[
      ...existingStateMessages.merge(updatedState.messages),
    ].sorted(_sortByCreatedAt);

    final existingStateRead = chatState.reads;
    final updatedStateRead = updatedState.reads;
    final newReads = <Read>[
      ...updatedStateRead,
      ...existingStateRead.where((r) =>
          !updatedStateRead.any((newRead) => newRead.user.id == r.user.id)),
    ];

    final newMembers = <Members>[
      ...updatedState.members,
    ];

    chatState = chatState.copyWith(
      messages: newMessages,
      reads: newReads,
      lastMessage: updatedState.lastMessage,
      lastMessageTime: updatedState.lastMessageAt,
      extraData: updatedState.extraData,
      members: newMembers,
      name: updatedState.name,
      image: updatedState.image,
    );
  }

  void _listenToNewMessage() {
    _brimChannel.on(
      EventType.messageNew,
      _newMessageListener,
    );

    _eventListeners[EventType.messageNew] = _newMessageListener;
  }

  void _newMessageListener(dynamic event) {
    if (event is Event) {
      final newMessage = event.brimMessage;

      if (newMessage != null) {
        updateMessage(newMessage);
      }
      unreadCount += 1;
    }
  }

  set unreadCount(int count) {
    final reads = [...read];
    final currentUserReadIndex = reads.indexWhere(_isCurrentUserReads);

    if (currentUserReadIndex < 0) return;

    reads[currentUserReadIndex] =
        reads[currentUserReadIndex].copyWith(unreadMessages: count);
    chatState = chatState.copyWith(reads: reads);
  }

  void deleteMessage(BrimMessage message, {bool hardDelete = false}) {
    if (hardDelete) return removeMessage(message);
    return updateMessage(message);
  }

  void removeMessage(BrimMessage message) {
    var updatedMessages = [...messages]..removeWhere((e) => e.id == message.id);

    chatState = chatState.copyWith(messages: updatedMessages);
  }

  bool _isCurrentUserReads(Read read) {
    return BrimAuth.curentUser()?.isMe(read.user.id) ?? false;
  }

  void updateMessage(BrimMessage message) {
    final newMessages = [...messages];

    final oldIndex = newMessages.indexWhere(
      (message) => message.trackingId == message.trackingId,
    );

    if (oldIndex != -1) {
      final oldMessage = newMessages[oldIndex];
      var updatedMessage = message.syncWith(oldMessage);

      newMessages[oldIndex] = updatedMessage;
    } else {
      newMessages.add(message);
    }

    chatState = chatState.copyWith(
      messages: newMessages.sorted(_sortByCreatedAt),
      lastMessageTime: message.createdAt,
    );
  }

  void _listenMessageDeleted() {
    _brimChannel.on(
      EventType.messageDeleted,
      _messageDeletedListener,
    );

    _eventListeners[EventType.messageDeleted] = _messageDeletedListener;
  }

  void _messageDeletedListener(dynamic event) {
    if (event is Event) {
      final deletedMessage = event.brimMessage;
      if (deletedMessage != null) {
        deleteMessage(deletedMessage, hardDelete: true);
      }
    }
  }

  final _isTypingController = BehaviorSubject.seeded(false);

  Stream<bool> get isTypingStream => _isTypingController.stream;

  bool get isTyping => _isTypingController.value;

  void _listenToTyping() {
    _brimChannel.on(EventType.typingStart, _typingListenerStart);

    _brimChannel.on(EventType.typingStop, _typingListenerStop);

    _eventListeners[EventType.typingStart] = _typingListenerStart;
    _eventListeners[EventType.typingStop] = _typingListenerStop;
  }

  void _typingListenerStart(dynamic event) {
    if (event is Event) {
      final currentUser = BrimAuth.curentUser();
      if (currentUser == null) return;
      final user = event.user;
      if (user != null && user.id != currentUser.id) {
        _isTypingController.add(false);
      }
    }
  }

  void _typingListenerStop(dynamic event) {
    if (event is Event) {
      final currentUser = BrimAuth.curentUser();

      if (currentUser == null) return;
      final user = event.user;
      if (user != null && user.id != currentUser.id) {
        _isTypingController.add(false);
      }
    }
  }

  void _listenToRead() {
    _brimChannel.on(
      EventType.messageRead,
      _readListener,
    );

    _eventListeners[EventType.messageRead] = _readListener;
  }

  void _readListener(dynamic event) {
    if (event is Event) {
      final readList = List<Read>.from(chatState.reads);
      final userReadIndex = read.indexWhere((r) => r.user.id == event.user!.id);

      if (userReadIndex != -1) {
        final userRead = readList.removeAt(userReadIndex);
        if (userRead.user.id == BrimAuth.curentUser()?.id) {
          unreadCount = 0;
        }
        readList.add(Read(
          user: event.user!,
          lastReadAt: event.createdAt,
          lastReadMessage: messages.lastOrNull?.id,
        ));

        chatState = chatState.copyWith(reads: readList);
      }
    }
  }

  void dispose() {
    _isTypingController.close();
    _chatStateController.close();
    if (_eventListeners.isNotEmpty) {
      _brimChannel.off(_eventListeners);
      _eventListeners.clear();
    }
  }
}

// Checks and removes stale typing events that were not explicitly stopped by
// the sender due to technical difficulties. e.g. process death, loss of
// Internet connection or custom implementation.
void _startCleaningStaleTypingEvents() {}

int _sortByCreatedAt(BrimMessage a, BrimMessage b) =>
    a.createdAt.compareTo(b.createdAt);

extension on Iterable<BrimMessage> {
  Iterable<BrimMessage> merge(Iterable<BrimMessage>? other) {
    if (other == null) return this;

    final messageMap = {for (final message in this) message.id: message};

    for (final message in other) {
      messageMap.update(
        message.id,
        message.syncWith,
        ifAbsent: () => message,
      );
    }

    return messageMap.values;
  }
}
