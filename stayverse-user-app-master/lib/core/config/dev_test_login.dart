import 'package:flutter/foundation.dart';
import 'package:stayverse/core/config/appEnviroment/enviroment.dart';

/// Local demo accounts — only when `mode=dev` in `.env` and running a debug build.
bool get kDevTestLoginEnabled => kDebugMode && environment.isDev;

class DevTestUserCredentials {
  DevTestUserCredentials._();

  static const String email = 'user.demo@stayverse.local';
  static const String password = 'Pass1234!';
}
