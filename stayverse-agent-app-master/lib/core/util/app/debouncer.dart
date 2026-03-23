import 'dart:async';

typedef DebounceCallBack = void Function();

class DebouncerService {
  DebouncerService({required this.interval});
  final Duration interval;

  ///Call back fuction
  DebounceCallBack? _action;

  Timer? _timer;

  void call(DebounceCallBack action, bool callImmediately) {
    _action = action;

    /// Cancle the previous request it there is one existing
    _timer?.cancel();

    if (callImmediately) {
      _callAction();
      return;
    }

    ///Start a new timer
    _timer = Timer(interval, _callAction);
  }

  ///Call the action and reset the timer
  void _callAction() {
    _action?.call();
    _timer = null;
  }

  ///Reset the bouncer
  void reset() {
    _action = null;
    _timer = null;
  }
}
