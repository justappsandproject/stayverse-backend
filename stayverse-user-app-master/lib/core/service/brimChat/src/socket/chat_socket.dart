import 'package:stayverse/core/socketio/base_socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as eng;

typedef ChatEventHandler = void Function(dynamic data);

class ChatSocketIO {
  static const String namespace = '/ws/chat';

  static eng.Socket? connect({String? customToken}) {
    return BaseSocketIO.connect(namespace, customToken: customToken);
  }

  static void emitEvent(String event, dynamic data) {
    BaseSocketIO.emitEvent(namespace, event, data);
  }

  static void withAck(String event, dynamic data) {
    BaseSocketIO.withAck(namespace, event, data);
  }

  static void listenWithAck(
      String event, Function(dynamic data, Function? ack) callback) {
    BaseSocketIO.listenWithAck(namespace, event, callback);
  }

  static bool get isConnect => BaseSocketIO.isConnect(namespace);

  static void listen(String event, Function(dynamic data) callback) {
    BaseSocketIO.listen(namespace, event, callback);
  }

  static void listenToMany(
    List<String> eventTypes,
    void Function(String event, dynamic data) callback,
  ) {
    BaseSocketIO.listenToAny(namespace, (String event, dynamic data) {
      if (eventTypes.contains(event)) {
        callback(event, data);
      }
    });
  }

  static void stopListeningToMany(Map<String, ChatEventHandler?> eventTypes) {
    eventTypes.forEach((event, callback) {
      stopListening(event, callback: callback);
    });
  }

  static void stopListening(String event, {ChatEventHandler? callback}) {
    BaseSocketIO.stopListening(namespace, event, callback: callback);
  }

  static eng.Socket? getInstance() {
    return BaseSocketIO.getInstance(namespace);
  }

  static void disconnect() {
    BaseSocketIO.disconnect(namespace);
  }
}
