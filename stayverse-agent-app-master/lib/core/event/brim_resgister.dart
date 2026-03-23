import 'package:stayvers_agent/core/event/brim_event.dart';
import 'package:stayvers_agent/core/event/evenList/load_storage_to_cache.dart';
import 'package:stayvers_agent/core/event/evenList/route_history_event.dart';

final Map<Type, BrimEvent> events = {
  RouteHistoryEvent: RouteHistoryEvent(),
  LoadStorageToCache: LoadStorageToCache(),
};

eventOn<T>({
  Map? params,
}) async {
  assert(T.toString() != 'dynamic',
      'You must provide an Event type for this method.\nE.g. event<LoginEvent>({"User": "#1 User"});');

  assert(events.containsKey(T),
      'Your config/events.dart is missing this class ${T.toString()}');

  Map<Type, BrimEvent> appEvents = events;

  BrimEvent brinoEvent = appEvents[T]!;

  Map<dynamic, BrimEventListener> listeners = brinoEvent.listeners();

  if (listeners.isEmpty) {
    return;
  }
  for (BrimEventListener listener in listeners.values.toList()) {
    listener.setEvent(brinoEvent);
    dynamic result = await listener.handle(params);
    if (result != null && result == false) {
      break;
    }
  }
}
