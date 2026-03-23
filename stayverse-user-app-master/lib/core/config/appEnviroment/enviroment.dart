import 'dart:io';

import 'package:stayverse/core/config/evn/env.dart';


enum Environment {
  mock,
  dev,
  prod,
  testing;

  static String _envMode = Env.mode;

  static Environment _derive() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return testing;
    }

    try {
      return Environment.values.byName(_envMode);
    } on ArgumentError {
      throw Exception(
          "Invalid runtime environment: '$_envMode'. Available environments: ${values.join(', ')}");
    }
  }

  bool get isMock => this == mock;

  bool get isDev => this == dev;

  bool get isProduction => this == prod;

  bool get isTesting => this == testing;

  bool get isDebugging {
    bool condition = false;
    assert(
      () {
        condition = true;
        return condition;
      }(),
    );
    return condition;
  }
}

Environment? _environment;

Environment get environment => _environment ??= Environment._derive();
