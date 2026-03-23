import 'package:stayverse/core/config/appEnviroment/enviroment.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/wrapper/notification/pusher/pusher.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

class StreamClientService {
  // Private constructor
  StreamClientService._internal();

  // Static instance variable
  static StreamClientService? _instance;

  // Factory constructor that returns the singleton instance
  factory StreamClientService() {
    _instance ??= StreamClientService._internal();
    return _instance!;
  }

  // Alternative getter method for accessing the instance
  static StreamClientService get instance {
    _instance ??= StreamClientService._internal();
    return _instance!;
  }

  StreamChatClient? _client;

  StreamChatClient? get clientStream => _client;

  void initClient(Environment environment) {
    _client = StreamChatClient(
      Env.getStreamKey,
      logLevel: environment.isProduction ? Level.OFF : Level.OFF,
    )..chatPersistenceClient = StreamChatPersistenceClient(
        logLevel: environment.isProduction ? Level.OFF : Level.OFF,
        connectionMode: ConnectionMode.regular,
      );
  }

  void connect() {
    final currentUser = BrimAuth.curentUser();

    final chatToken = BrimAuth.token(tokenKey: Env.chatToken);

    if (currentUser == null || chatToken == null) {
      return;
    }

    _client?.connectUser(
      User(
        id: currentUser.id ?? '',
        name: currentUser.fullName,
        image: currentUser.profilePicture,
      ),
      chatToken,
    );
  }

  void dispose() {
    _client?.disconnectUser(flushChatPersistence: true);
  }

  void pushToken() async {
    final deviceToken = await BrimPusher.getDeviceToken();
    if (deviceToken == null) {
      return;
    }
    await _client?.addDevice(deviceToken, PushProvider.firebase,
        pushProviderName: 'Stayverse');
  }
}
