import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/storage/brim_storage.dart';
import 'package:stayverse/core/util/app/helper.dart';

class BrimPusher {
  static Future<String?> _getDeviceToken() async {
    String? deviceToken;

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        deviceToken = await FirebaseMessaging.instance.getToken();
      } else {
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          deviceToken = await FirebaseMessaging.instance.getToken();
        }
      }
    } else {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }

    return deviceToken;
  }

  static Future<String?> getDeviceToken() async {
    return await _getDeviceToken();
  }

  static Future<ServerResponse?> pushToken({bool? notificationEnabled}) async {
    try {
      final deviceToken = await _getDeviceToken();

      if (isEmpty(deviceToken)) {
        return null;
      }

      final bool isNotificationEnabled = notificationEnabled ??
          BrimAuth.curentUser()?.notificationsEnabled ??
          true;

      final response = await locator.get<Dio>().patch<DynamicMap>(
          '${Constant.host}/users/notifications/device-token',
          data: {'deviceToken': deviceToken, 'enable': isNotificationEnabled});

      if (response.statusCode == HttpStatus.ok) {
        if (isNotEmpty(deviceToken)) {
          BrimStorage.instance.store(Constant.deviceToken, deviceToken!);
        }
      }
      return ServerResponse.fromJson(response.data!);
    } on DioException catch (e) {
      logger.d('Pusher ${e.message} ${e.response?.data}');
      return null;
    }
  }
}
