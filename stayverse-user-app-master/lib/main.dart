import 'dart:io' show Platform;

import 'package:stayverse/app.dart';
import 'package:stayverse/core/brimEngine/bootLoaders/brim_boot.dart';
import 'package:stayverse/core/brimEngine/brim_engine.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/appEnviroment/enviroment.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/config/deviceInfo/app_device_information.dart';
import 'package:stayverse/core/config/errorhandling/error_boundary.dart';
import 'package:stayverse/core/config/errorhandling/error_reporter.dart';
import 'package:stayverse/core/config/errorhandling/sentry_client_reporter.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry/sentry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stayverse/firebase_options.dart';
import 'package:stayverse/shared/app_crash_view.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ReporterClient? reporterClient;

  final DeviceInformation deviceInformation =
      await AppDeviceInformation.initialize();

  switch (environment) {
    case Environment.dev:
      Logger.level = Level.all;

      Constant.host =
          _devApiBaseUrl(Env.hostDev, deviceInformation);

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

  // ignore: unused_local_variable
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
      },
      onCrash: errorReporter.reportCrash,
      child: const ProviderScope(
        child: StayverseApp(),
      ),
    ),
  );
}

/// Physical Android devices cannot use the emulator-only host `10.0.2.2`.
/// When `.env` still points there, rewrite to `127.0.0.1` so
/// `adb reverse tcp:<port> tcp:<port>` forwards to your machine.
String _devApiBaseUrl(String configured, DeviceInformation device) {
  if (!Platform.isAndroid || !device.isPhysicalDevice) return configured;
  final uri = Uri.tryParse(configured);
  if (uri == null || uri.host != '10.0.2.2') return configured;
  return Uri(
    scheme: uri.scheme.isEmpty ? 'http' : uri.scheme,
    host: '127.0.0.1',
    port: uri.hasPort ? uri.port : null,
  ).toString();
}
