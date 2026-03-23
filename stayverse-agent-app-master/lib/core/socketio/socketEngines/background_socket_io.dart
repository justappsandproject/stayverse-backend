import 'package:stayvers_agent/core/socketio/base_socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as eng;

class BackgroundSocketIO {
  static const String namespace = '/background';

  static eng.Socket? connect({String? customToken}) {
    return BaseSocketIO.connect(namespace, customToken: customToken);
  }

  static eng.Socket? getInstance() {
    return BaseSocketIO.getInstance(namespace);
  }

  static void listenForLocationUpdates(
      Function(double lat, double lng) callback) {
    BaseSocketIO.listen(
        namespace, 'updated', (data) => callback(data['lat'], data['lng']));
  }

  static bool get isConnect => BaseSocketIO.isConnect(namespace);

  static void disconnect() {
    BaseSocketIO.disconnect(namespace);
  }
}

class BackgroundSocketEvent {
  static const String driverLocation = 'driver.updateLocation';
}
