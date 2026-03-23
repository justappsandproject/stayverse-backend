import 'dart:collection';
import 'dart:io';

import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as eng;

typedef AnyEventHandler = void Function(String event, dynamic data);

class BaseSocketIO {
  static final HashMap<String, eng.Socket> _namespaces = HashMap();

  static eng.Socket? connect(String namespace, {String? customToken}) {
    final token = customToken ?? BrimAuth.token();
    if (token == null) {
      return null;
    }
    if (_namespaces.containsKey(namespace)) {
      return _namespaces[namespace];
    }

    final socket = eng.io(
        '${Constant.host}$namespace',
        eng.OptionBuilder().setTransports(['websocket']).setQuery({
          'role': Constant.role
        }).setExtraHeaders(
            {HttpHeaders.authorizationHeader: 'Bearer $token'}).build());

    _setupListeners(socket);
    _namespaces[namespace] = socket;

    return socket;
  }

  static eng.Socket? getInstance(String namespace) {
    return _namespaces[namespace];
  }

  static void _setupListeners(eng.Socket socket) {
    socket.onConnect((_) => debugPrint('Connected to ${socket.nsp}'));
    socket.onDisconnect((_) => debugPrint('Disconnected from ${socket.nsp}'));
    socket.onConnectError(
        (err) => debugPrint('Connect error ${socket.nsp}: $err'));
    socket.onError((err) => debugPrint('Error ${socket.nsp}: $err'));
  }

  static void emitEvent(String namespace, String event, dynamic data) {
    _namespaces[namespace]?.emit(event, data);
  }

  static void withAck(String namespace, String event, dynamic data) {
    _namespaces[namespace]?.emitWithAck(event, data,
        ack: (data) => debugPrint("ack from $namespace: $data"));
  }

  static void listenWithAck(String namespace, String event,
      Function(dynamic data, Function? ack) callback) {
    _namespaces[namespace]?.on(event, (data) {
      final dataList = data as List;
      callback(dataList.firstOrNull, dataList.lastOrNull as Function?);
    });
  }

  static bool isConnect(String namespace) {
    return _namespaces[namespace]?.connected ?? false;
  }

  static void listen(
      String namespace, String event, Function(dynamic data) callback) {
    _namespaces[namespace]?.on(event, (data) => callback(data));
  }

  static void listenToAny<T>(String namespace, AnyEventHandler handler) {
    _namespaces[namespace]?.onAny(handler);
  }

  static void stopListening(String namespace, String event,
      {Function(dynamic data)? callback}) {
    _namespaces[namespace]?.off(event, callback);
  }

  static void disconnect(String namespace) {
    _namespaces[namespace]?.disconnect();
    _namespaces.remove(namespace);
  }

  static void disconnectAll() {
    _namespaces.forEach((_, socket) => socket.disconnect());
    _namespaces.clear();
  }
}
