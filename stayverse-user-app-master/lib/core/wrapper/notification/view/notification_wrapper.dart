import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/wrapper/notification/pusher/pusher.dart';

class NotificationWrapper extends StatefulWidget {
  const NotificationWrapper(
      {super.key,
      required this.child,
      this.onTapWhenAppInBackground,
      this.onTapWhenAppIsTerminated,
      this.onForeGroundNotificationReceived});

  final Widget child;

  final Function(RemoteMessage message)? onTapWhenAppInBackground;

  final Function(RemoteMessage message)? onTapWhenAppIsTerminated;

  final Function(RemoteMessage message)? onForeGroundNotificationReceived;

  @override
  State<NotificationWrapper> createState() => _NotificationConfigState();
}

class _NotificationConfigState extends State<NotificationWrapper> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => startNotificationProcess(),
    );
  }

  void startNotificationProcess() async {
    await askForPermission();
    await setUpIOSNotification();
    onForeGroundNotification();
    await setupInteractedMessage();
    registerTokenUpdate();
  }


  void registerTokenUpdate() {
    FirebaseMessaging.instance.onTokenRefresh.listen((id) {
      BrimPusher.pushToken();
    });
  }

  setUpIOSNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///Ask for user permission
  Future<void> askForPermission() async {
    NotificationSettings isPermissionGranted =
        await messaging.getNotificationSettings();

    if (isPermissionGranted.authorizationStatus !=
        AuthorizationStatus.authorized) {
      await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  ///ForeGround handler
  ///When your app is currently in use and notification is received
  void onForeGroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      widget.onForeGroundNotificationReceived?.call(message);
    });
  }

  ///Handle notification when they are clicked
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // A terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // Handle if the app was open from notification
    if (initialMessage != null) {
      _handleTapWhenAppIsTerminated(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTapFromBackground);
  }

  void _handleTapWhenAppIsTerminated(RemoteMessage message) {
    widget.onTapWhenAppInBackground?.call(message);
  }

  void _handleTapFromBackground(RemoteMessage message) {
    widget.onTapWhenAppInBackground?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
