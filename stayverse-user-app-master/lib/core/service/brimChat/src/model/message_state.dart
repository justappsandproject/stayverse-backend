// ---- MessageState and Subclasses ----
sealed class MessageState {
  const MessageState();
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageOutgoing extends MessageState {
  final OutgoingState state;
  const MessageOutgoing(this.state);
}

class MessageCompleted extends MessageState {
  final CompletedState state;
  const MessageCompleted(this.state);
}

class MessageFailed extends MessageState {
  final FailedState state;
  final Object? reason;
  const MessageFailed(this.state, {this.reason});
}

// ---- OutgoingState ----
sealed class OutgoingState {
  const OutgoingState();
}

class Sending extends OutgoingState {
  const Sending();
}

class Updating extends OutgoingState {
  const Updating();
}

class Deleting extends OutgoingState {
  final bool hard;
  const Deleting({this.hard = false});
}

// ---- CompletedState ----
sealed class CompletedState {
  const CompletedState();
}

class Sent extends CompletedState {
  const Sent();
}

class Updated extends CompletedState {
  const Updated();
}

class Deleted extends CompletedState {
  final bool hard;
  const Deleted({this.hard = false});
}

// ---- FailedState ----
sealed class FailedState {
  const FailedState();
}

class SendingFailed extends FailedState {
  const SendingFailed();
}

class UpdatingFailed extends FailedState {
  const UpdatingFailed();
}

class DeletingFailed extends FailedState {
  final bool hard;
  const DeletingFailed({this.hard = false});
}
