import 'package:stayverse/core/service/brimChat/src/model/message_state.dart';

extension MessageStateX on MessageState {
  bool get isInitial => this is MessageInitial;

  bool get isOutgoing => this is MessageOutgoing;

  bool get isCompleted => this is MessageCompleted;

  bool get isFailed => this is MessageFailed;

  bool get isSending =>
      this is MessageOutgoing && (this as MessageOutgoing).state is Sending;

  bool get isUpdating =>
      this is MessageOutgoing && (this as MessageOutgoing).state is Updating;

  bool get isDeleting => isSoftDeleting || isHardDeleting;

  bool get isSoftDeleting =>
      this is MessageOutgoing &&
      (this as MessageOutgoing).state is Deleting &&
      !((this as MessageOutgoing).state as Deleting).hard;

  bool get isHardDeleting =>
      this is MessageOutgoing &&
      (this as MessageOutgoing).state is Deleting &&
      ((this as MessageOutgoing).state as Deleting).hard;

  bool get isSent =>
      this is MessageCompleted && (this as MessageCompleted).state is Sent;

  bool get isUpdated =>
      this is MessageCompleted && (this as MessageCompleted).state is Updated;

  bool get isDeleted => isSoftDeleted || isHardDeleted;

  bool get isSoftDeleted =>
      this is MessageCompleted &&
      (this as MessageCompleted).state is Deleted &&
      !((this as MessageCompleted).state as Deleted).hard;

  bool get isHardDeleted =>
      this is MessageCompleted &&
      (this as MessageCompleted).state is Deleted &&
      ((this as MessageCompleted).state as Deleted).hard;

  bool get isSendingFailed =>
      this is MessageFailed && (this as MessageFailed).state is SendingFailed;

  bool get isUpdatingFailed =>
      this is MessageFailed && (this as MessageFailed).state is UpdatingFailed;

  bool get isDeletingFailed => isSoftDeletingFailed || isHardDeletingFailed;

  bool get isSoftDeletingFailed =>
      this is MessageFailed &&
      (this as MessageFailed).state is DeletingFailed &&
      !((this as MessageFailed).state as DeletingFailed).hard;

  bool get isHardDeletingFailed =>
      this is MessageFailed &&
      (this as MessageFailed).state is DeletingFailed &&
      ((this as MessageFailed).state as DeletingFailed).hard;
}
