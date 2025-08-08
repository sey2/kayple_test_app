import 'package:flutter/foundation.dart';

// app TODO: AppLogger 구현
abstract final class ErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);
  }

  static bool handlePlatformDispatcherError(Object error, StackTrace stack) {
    if (kDebugMode) {
      print("Uncaught error in PlatformDispatcher: $error\nStackTrace:$stack");
    }

    return true;
  }

  static void handleUncaughtError(Object error, StackTrace stack) {
    if (kDebugMode) {
      print("Uncaught error in main:  $error\nStackTrace:$stack");
    }
  }
}
