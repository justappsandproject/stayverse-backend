import 'package:stayverse/core/service/brimChat/src/model/message_state.dart';

class MessageStates {
  static const MessageState inital = MessageInitial();
  static const MessageState sending = MessageOutgoing(Sending());

  static const MessageState updating = MessageOutgoing(Updating());

  static const MessageState softDeleting = MessageOutgoing(Deleting());

  static const MessageState hardDeleting =
      MessageOutgoing(Deleting(hard: true));

  static const MessageState sent = MessageCompleted(Sent());

  static const MessageState updated = MessageCompleted(Updated());

  static const MessageState softDeleted = MessageCompleted(Deleted());

  static const MessageState hardDeleted = MessageCompleted(Deleted(hard: true));

  static const MessageState sendingFailed = MessageFailed(SendingFailed());

  static const MessageState updatingFailed = MessageFailed(UpdatingFailed());

  static const MessageState softDeletingFailed =
      MessageFailed(DeletingFailed());

  static const MessageState hardDeletingFailed =
      MessageFailed(DeletingFailed(hard: true));

  static MessageState deleting({required bool hard}) =>
      MessageOutgoing(Deleting(hard: hard));

  static MessageState deleted({required bool hard}) =>
      MessageCompleted(Deleted(hard: hard));

  static MessageState deletingFailed({required bool hard}) =>
      MessageFailed(DeletingFailed(hard: hard));
}
