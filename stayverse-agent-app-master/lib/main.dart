import 'package:firebase_core/firebase_core.dart';
import 'package:stayvers_agent/app.dart';
import 'package:stayvers_agent/core/brimEngine/bootLoaders/brim_boot.dart';
import 'package:stayvers_agent/core/brimEngine/brim_engine.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/appEnviroment/enviroment.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/config/deviceInfo/app_device_information.dart';
import 'package:stayvers_agent/core/config/errorhandling/error_boundary.dart';
import 'package:stayvers_agent/core/config/errorhandling/error_reporter.dart';
import 'package:stayvers_agent/core/config/errorhandling/sentry_client_reporter.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry/sentry.dart';
import 'package:stayvers_agent/firebase_options.dart';
import 'package:stayvers_agent/shared/app_crash_view.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ReporterClient? reporterClient;

  final DeviceInformation deviceInformation =
      await AppDeviceInformation.initialize();

  switch (environment) {
    case Environment.dev:
      Logger.level = Level.all;

      Constant.host = Env.hostDev;

      reporterClient = SenrtyClientReporter(
        SentryClient(SentryOptions(dsn: Env.sentryDns)),
        deviceInformation: deviceInformation,
        environment: environment,
      );

    case Environment.prod:
      Logger.level = Level.off;
      Constant.host = Env.hostprod;

      reporterClient = SenrtyClientReporter(
        SentryClient(SentryOptions(dsn: Env.sentryDns)),
        deviceInformation: deviceInformation,
        environment: environment,
      );

    case Environment.testing:
    case Environment.mock:
  }

  final ErrorReporter errorReporter = ErrorReporter(client: reporterClient);

  await BrimEngine.instance.boot(
    setup: () => BrimBoot.brim(),
    setupFinished: () => BrimBoot.finished(),
  );

  locator.get<BrimDeviceInfo>().installGlobalDeviceInfo(deviceInformation);

  
  runApp(
    ErrorBoundary(
      isReleaseMode: !environment.isDebugging,
      errorViewBuilder: (_) => const AppCrashErrorView(),
      onException: (e, st) {
        errorReporter.report(e, st);
        // getLogger(ErrorBoundary).d(st, stackTrace: st);
      },
      onCrash: errorReporter.reportCrash,
      child: const ProviderScope(
        child: StayVerseAgent(),
      ),
    ),
  );
}
