import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/streamChat/stream_client_service.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CommnunicationSevice {
  CommnunicationSevice._();

  static final _instance = CommnunicationSevice._();

  static final instance = _instance;

  factory CommnunicationSevice() => _instance;

  Channel? chatAgent(
      {String? title, required String myId, required String agentId}) {
    if (!BrimAuth.isLoggeIn()) {
      BrimToast.showError('Log in/Sign Up to Chat a Agent',
          title: 'Chat Agent');
      return null;
    }
    final channel =
        getChannel(title: title ?? '', myId: myId, agentId: agentId);

    if (channel == null) {
      BrimToast.showError(
          'Could not open chat at this moment, Try calling this Agent',
          title: 'Call Agent');
    }

    return channel;
  }

  Channel? getChannel(
      {required String myId, required String agentId, required String title}) {
    final client = StreamClientService.instance.clientStream;
    return client?.channel('messaging', extraData: {
      'members': [myId, agentId],
      'agent': {'title': title}
    });
  }
}
