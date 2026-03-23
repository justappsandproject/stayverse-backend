import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class BrimLogger {
  static Logger load(Object value) {
    return Logger(
      printer: SimpleLogPrinter(
        value.toString(),
      ),
    );
  }
}


class SimpleLogPrinter extends LogPrinter {
  final String className;

  SimpleLogPrinter(
    this.className,
  );

  @override
  List<String> log(LogEvent event) {
    AnsiColor? color = PrettyPrinter.defaultLevelColors[event.level];
    String? emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    if (kDebugMode) {
      debugPrint(
        color!(
          '$emoji $className - ${event.message}',
        ),
      );
    }

    return [];
  }
}
