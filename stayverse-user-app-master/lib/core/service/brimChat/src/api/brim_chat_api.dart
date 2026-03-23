import 'package:dio/dio.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/brimChat/src/api/model/datasource/brimchat_network_service.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/pagination.dart';
import 'package:stayverse/core/service/brimChat/src/model/chat_state.dart';

class BrimChatApi {
  static BrimchatNetworkService get _apiClient =>
      locator.get<BrimchatNetworkService>();

  static Future<BrimMessage?> sendMessage(BrimMessage message) async {
    try {
      ServerResponse? serverResponse = await _apiClient.sendMessage(message);

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final sentMessage =
          BrimMessage.fromJson(serverResponse?.data as DynamicMap);
      return sentMessage;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Query chats with pagination
  static Future<List<ChatState>?> queryChats({
    BrimPagination? pagination,
    BrimPagination? messagePagination,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.queryChats(
        pagination: pagination,
        messagePagination: messagePagination,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final chatsData = serverResponse?.data as List<dynamic>;
      final chats = chatsData
          .map((chatJson) => ChatState.fromJson(chatJson as DynamicMap))
          .toList();

      return chats;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Query a specific chat by ID
  static Future<ChatState?> queryChat(
    String chatId, {
    BrimPagination? messagesPagination,
    Map<String, dynamic>? data,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.getChat(
        chatId,
        messagesPagination: messagesPagination,
        data: data,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final chat = ChatState.fromJson(serverResponse?.data as DynamicMap);
      return chat;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Query messages for a specific chat
  static Future<List<BrimMessage>?> queryMessages(
    String chatId, {
    BrimPagination? messagePagination,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.queryMessages(
        chatId,
        messagePagination: messagePagination,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final messagesData = serverResponse?.data as List<dynamic>;
      final messages = messagesData
          .map((messageJson) => BrimMessage.fromJson(messageJson as DynamicMap))
          .toList();

      return messages;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Query a specific message by ID
  static Future<BrimMessage?> queryMessage(String messageId) async {
    try {
      ServerResponse? serverResponse = await _apiClient.queryMessage(messageId);

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final message = BrimMessage.fromJson(serverResponse?.data as DynamicMap);
      return message;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Delete a specific message
  static Future<bool> deleteMessage(
    String messageId, {
    bool? hard,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.deleteMessage(
        messageId,
        hard: hard,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return false;
      }

      return true;
    } on BrimAppException catch (_) {
      return false;
    }
  }

  /// Request attachment upload URL
  static Future<List<String>?> requestAttachmentUploadUrl(
    List<Attachment> attachments,
  ) async {
    try {
      ServerResponse? serverResponse =
          await _apiClient.requestAttachmentUploadUrl(attachments);

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final uploadUrls = (serverResponse?.data as List<dynamic>)
          .map((url) => url as String)
          .toList();

      return uploadUrls;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Upload attachment to external storage
  static Future<Attachment?> attachmentUpload(
    String uploadUrl, {
    required Attachment attachment,
    CancelToken? cancelToken,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.attachmentUpload(
        uploadUrl,
        attachment: attachment,
        cancelToken: cancelToken,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final uploadedAttachment =
          Attachment.fromJson(serverResponse?.data as DynamicMap);
      return uploadedAttachment;
    } on BrimAppException catch (_) {
      return null;
    }
  }

  /// Delete an attachment
  static Future<bool> deleteAttachment(
    String url,
    String chatId,
  ) async {
    try {
      ServerResponse? serverResponse =
          await _apiClient.deleteAttahment(url, chatId);

      if (errorOccured(serverResponse, showToast: false)) {
        return false;
      }

      return true;
    } on BrimAppException catch (_) {
      return false;
    }
  }

  /// Mark messages as read
  static Future<bool> markAsRead({
    required String lastReadMessageId,
    required String chatId,
  }) async {
    try {
      ServerResponse? serverResponse = await _apiClient.markAsRead(
        lastReadMessageId: lastReadMessageId,
        chatId: chatId,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return false;
      }

      return true;
    } on BrimAppException catch (_) {
      return false;
    }
  }
}
