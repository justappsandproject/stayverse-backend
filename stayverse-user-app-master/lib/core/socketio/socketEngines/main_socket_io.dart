import 'package:stayverse/core/socketio/base_socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as eng;

class MainSocketIO {
  static const String namespace = '/ws';

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

  static void stopListening(String event, {Function(dynamic data)? callback}) {
    BaseSocketIO.stopListening(namespace, event, callback: callback);
  }

  static eng.Socket? getInstance() {
    return BaseSocketIO.getInstance(namespace);
  }

  static void disconnect() {
    BaseSocketIO.disconnect(namespace);
  }
}

class MainSocketEvent {
  static const String driverLocation = 'rider.example.location';
}
