
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/chat_message_model.dart';

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void sendMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().toString(),
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
    );
    state = [...state, message];
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});
