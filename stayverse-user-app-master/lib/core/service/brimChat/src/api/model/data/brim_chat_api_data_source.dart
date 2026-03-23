import 'package:dio/dio.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/pagination.dart';

abstract class BrimChatApiDataSource<T> {
  //Send message to a specific chat
  Future<T?> sendMessage(BrimMessage message);

  ///Query chats by pagination
  Future<T?> queryChats({
    BrimPagination? pagination,
    BrimPagination? messagePagination,
  });

  /// Queries a specific chat by its ID.
  /// if Chat id does not exist, it will create and return a chat.
  Future<T?> getChat(String chatId,
      {BrimPagination? messagesPagination, Map<String, dynamic>? data});

  /// Query messages by pagination
  Future<T?> queryMessages(
    String chatId, {
    BrimPagination? messagePagination,
  });

  /// Query a specific message
  Future<T?> queryMessage(String messageId);

  /// Delete a specific message
  Future<T?> deleteMessage(
    String messageId, {
    bool? hard,
  });

  /// Request attachment upload url(for external storage)
  Future<T?> requestAttachmentUploadUrl(List<Attachment> attachment);

  /// Upload attachment to external storage
  Future<T?> attachmentUpload(
    String uploadUrl, {
    required Attachment attachment,
    CancelToken? cancelToken,
  });

  Future<T?> deleteAttahment(
    String url,
    String chatId,
  );

  ///Mark lastReadMessageId as read
  ///any previous message is mark as read
  Future<T?> markAsRead(
      {required String lastReadMessageId, required String chatId});
}
