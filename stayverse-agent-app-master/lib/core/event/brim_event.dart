abstract class BrimEvent {
  Map<Type, BrimEventListener> listeners();
}

class BrimEventListener {
  late BrimEvent _event;

  setEvent(BrimEvent event) {
    _event = event;
  }

  BrimEvent getEvent() => _event;

  Future<dynamic> handle(Map? event) async {}
}
