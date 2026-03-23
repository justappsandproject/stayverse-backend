import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/feature/messaging/view/ui_state/chat_ui_state.dart';

class ChatController extends StateNotifier<ChatUiState>
    with CheckForServerError {
  ChatController() : super(const ChatUiState());

  

  reset() {
    isbusy(false);
  }

  isbusy(bool loading) {
    state = state.copy(isBusy: loading);
  }
}

final chatController =
    StateNotifierProvider.autoDispose<ChatController, ChatUiState>((ref) {
  return ChatController();
});
