import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/brimChat/src/api/model/data/brim_chat_api_data_source.dart';
import 'package:stayverse/core/service/brimChat/src/api/model/datasource/brimchat_network_repository.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/pagination.dart';
import 'package:stayverse/core/util/app/logger.dart';

class BrimchatNetworkService extends BrimChatApiDataSource<ServerResponse> {
  final BrimChatNetworkRepository _repository;

  BrimchatNetworkService(this._repository);

  final log = BrimLogger.load('BrimchatNetworkService');

  @override
  Future<ServerResponse?> attachmentUpload(String uploadUrl,
      {required Attachment attachment, CancelToken? cancelToken}) async {
    try {
      log.i("::::====> Uploading Attachment : ${attachment.name}");

      return await _repository.attachmentUpload(
        uploadUrl,
        attachment: attachment,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      log.e("Error uploading attachment ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteAttahment(String url, String chatId) async {
    try {
      log.i("::::====> Deleting Attachment : $url in chat: $chatId");

      return await _repository.deleteAttahment(url, chatId);
    } on DioException catch (e) {
      log.e("Error deleting attachment ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteMessage(String messageId, {bool? hard}) async {
    try {
      log.i("::::====> Deleting Message : $messageId");

      return await _repository.deleteMessage(messageId, hard: hard);
    } on DioException catch (e) {
      log.e("Error deleting message ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> markAsRead(
      {required String lastReadMessageId, required String chatId}) async {
    try {
      log.i(
          "::::====> Marking as read - Message: $lastReadMessageId, Chat: $chatId");

      return await _repository.markAsRead(
        lastReadMessageId: lastReadMessageId,
        chatId: chatId,
      );
    } on DioException catch (e) {
      log.e("Error marking as read ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getChat(String chatId,
      {BrimPagination? messagesPagination, Map<String, dynamic>? data}) async {
    try {
      log.i("::::====> Querying Chat : $chatId");

      return await _repository.queryChat(
        chatId,
        messagesPagination: messagesPagination,
        data: data,
      );
    } on DioException catch (e) {
      log.e("Error querying chat ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> queryChats(
      {BrimPagination? pagination, BrimPagination? messagePagination}) async {
    try {
      log.i("::::====> Querying Chats");

      return await _repository.queryChats(
        pagination: pagination,
        messagePagination: messagePagination,
      );
    } on DioException catch (e) {
      log.e("Error querying chats ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> queryMessage(String messageId) async {
    try {
      log.i("::::====> Querying Message : $messageId");

      return await _repository.queryMessage(messageId);
    } on DioException catch (e) {
      log.e("Error querying message ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> queryMessages(String chatId,
      {BrimPagination? messagePagination}) async {
    try {
      log.i("::::====> Querying Messages for Chat : $chatId");

      return await _repository.queryMessages(
        chatId,
        messagePagination: messagePagination,
      );
    } on DioException catch (e) {
      log.e("Error querying messages ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> requestAttachmentUploadUrl(
      List<Attachment> attachment) async {
    try {
      log.i(
          "::::====> Requesting Upload URL for ${attachment.length} attachments");

      return await _repository.requestAttachmentUploadUrl(attachment);
    } on DioException catch (e) {
      log.e("Error requesting attachment upload URL ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> sendMessage(BrimMessage message) async {
    try {
      log.i("::::====> Sending Message : ${message.content}");

      return await _repository.sendMessage(message);
    } on DioException catch (e) {
      log.e("Error sending message ::::=====> ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
