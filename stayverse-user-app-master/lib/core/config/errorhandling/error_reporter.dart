// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

class ErrorReporter {
  ErrorReporter({
    required this.client,
  });

  final ReporterClient? client;

  final Duration _lockDuration = const Duration(seconds: 10);

  DateTime? _lastReportTime;

  bool get _reportLocked =>
      _lastReportTime != null &&
      clock.now().difference(_lastReportTime!) < _lockDuration;

  Future<void> report(Object error, StackTrace stackTrace,
      [Object? extra]) async {
    if (_reportLocked) {
      return;
    }

    _lastReportTime = clock.now();

    try {
      await client?.report(error: error, stackTrace: stackTrace, extra: extra);
    } catch (e) {
      log(e);
    }
  }

  Future<void> reportCrash(FlutterErrorDetails details) async =>
      client?.reportCrash(details);

  void log(Object object) => client?.log(object);
}

abstract class ReporterClient {
  FutureOr<void> report(
      {required StackTrace stackTrace, required Object error, Object? extra});

  FutureOr<void> reportCrash(FlutterErrorDetails details);

  void log(Object object);
}
