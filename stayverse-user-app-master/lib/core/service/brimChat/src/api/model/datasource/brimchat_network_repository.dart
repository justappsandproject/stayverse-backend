import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/core/service/brimChat/src/model/attachment.dart';
import 'package:stayverse/core/service/brimChat/src/model/message.dart';
import 'package:stayverse/core/service/brimChat/src/model/pagination.dart';

class _BrimChatPath {
  static String message = "/chat/messages";
  static String chats = "/chat/chats";
  static String chat = "/chat";
  static String attachmentUpload = "/chat/attachment/upload";
  static String attachmentDelete = "/chat/attachment/delete";
  static String markRead = "/chat/mark-read";
}

class BrimChatNetworkRepository {
  final log = BrimLogger.load("BrimChatNetworkRepository");

  BrimChatNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> sendMessage(BrimMessage message) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.message}",
      data: message.toJson(),
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> queryChats({
    BrimPagination? pagination,
    BrimPagination? messagePagination,
  }) async {
    final queryParams = <String, dynamic>{};

    if (pagination != null) {
      queryParams.addAll(pagination.toQueryParams());
    }

    if (messagePagination != null) {
      queryParams.addAll(messagePagination.toQueryParams());
    }

    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.chats}",
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> queryChat(
    String? chatId, {
    BrimPagination? messagesPagination,
    Map<String, dynamic>? data,
  }) async {
    var url = "${dio.options.baseUrl}${_BrimChatPath.chat}";

    if (chatId != null) {
      url = "$url/$chatId";
    }

    final queryParams = <String, dynamic>{};

    if (messagesPagination != null) {
      queryParams.addAll(messagesPagination.toQueryParams());
    }

    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.chat}/$chatId",
      data: data,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> queryMessages(
    String chatId, {
    BrimPagination? messagePagination,
  }) async {
    final queryParams = <String, dynamic>{};

    if (messagePagination != null) {
      queryParams.addAll(messagePagination.toQueryParams());
    }

    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.message}/$chatId",
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> queryMessage(String messageId) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.message}/$messageId",
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> deleteMessage(
    String messageId, {
    bool? hard,
  }) async {
    final queryParams = <String, dynamic>{};

    if (hard != null) {
      queryParams['hard'] = hard;
    }

    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.message}/$messageId",
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> requestAttachmentUploadUrl(
      List<Attachment> attachment) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.attachmentUpload}",
      data: {
        'attachments': attachment.map((a) => a.toJson()).toList(),
      },
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> attachmentUpload(
    String uploadUrl, {
    required Attachment attachment,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData();

    if (attachment.file != null) {
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(
          attachment.file!.path,
          filename: attachment.name,
        ),
      ));
    }

    final result = await dio.post<DynamicMap>(
      uploadUrl,
      data: formData,
      cancelToken: cancelToken,
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> deleteAttahment(
    String url,
    String chatId,
  ) async {
    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.attachmentDelete}",
      data: {
        'url': url,
        'chatId': chatId,
      },
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> markAsRead({
    required String lastReadMessageId,
    required String chatId,
  }) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_BrimChatPath.markRead}",
      data: {
        'lastReadMessageId': lastReadMessageId,
        'chatId': chatId,
      },
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
