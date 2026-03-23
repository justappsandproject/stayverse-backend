import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/event/brim_event.dart';
import 'package:stayvers_agent/core/service/storage/brim_storage.dart';

class RouteHistoryEvent extends BrimEvent {
  @override
  Map<Type, BrimEventListener> listeners() {
    return {_RouteHistoryListener: _RouteHistoryListener()};
  }
}

class _RouteHistoryListener extends BrimEventListener {
  @override
  handle(Map? event) async {
    if (event == null) return;
    await BrimStorage.instance.store(
      Env.screenStorageScreen,
      event[Env.screenStorageScreen],
    );
  }
}
