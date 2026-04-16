import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stayverse/core/service/toast_service.dart';

class NotificationMessageHandler {
  static void handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final title = message.notification?.title?.trim();
    final body = message.notification?.body?.trim();
    final type = data['type']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    if (type == 'curated_message') {
      BrimToast.showInfo(
        body?.isNotEmpty == true ? body! : 'You have a new curated message.',
        title: title?.isNotEmpty == true ? title : 'Curated Message',
        duration: const Duration(seconds: 5),
      );
      return;
    }

    BrimToast.showInfo(
      body?.isNotEmpty == true ? body! : 'You have a new notification.',
      title: title?.isNotEmpty == true ? title : 'Notification',
    );
  }
}
