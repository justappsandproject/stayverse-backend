import 'package:stayverse/core/brimEngine/brim_engine.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/route/generate_route.dart';
import 'package:stayverse/core/service/streamChat/stream_chat_builder.dart';
import 'package:stayverse/core/util/style/theme.dart';
import 'package:stayverse/core/wrapper/notification/notification_message_handler.dart';
import 'package:stayverse/core/wrapper/notification/view/notification_wrapper.dart';
import 'package:stayverse/feature/splashScreen/view/page/splash_screen_page.dart';
import 'package:stayverse/shared/app_scroll_behavior.dart';

class StayverseApp extends StatelessWidget {
  const StayverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onForeGroundNotificationReceived:
          NotificationMessageHandler.handleForegroundMessage,
      child: ScreenUtilInit(
        designSize: BrimEngine.instance.deviceSize,
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: $appKey,
          builder: (context, child) {
            return StreamChatBuilder(child: child);
          },
          themeMode: ThemeMode.light,
          initialRoute: SplashScreenPage.route,
          onGenerateRoute: RouteGenerator.generateRoute,
          scrollBehavior: AppScrollBehavior(),
          theme: AppTheme.toThemeData(styles: $styles, isDark: false),
          darkTheme: AppTheme.toThemeData(styles: $styles, isDark: true),
        ),
      ),
    );
  }
}
