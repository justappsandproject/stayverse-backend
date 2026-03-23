library brim_chat;

import 'package:stayverse/core/service/brimChat/src/socket/chat_socket.dart';
export 'src/brim_chat_channel.dart';
export 'src/brim_chat_channel_state.dart';

class BrimChat {
  /// Connects to the chat socket.
  static connect() {
    ChatSocketIO.connect();
  }
}
