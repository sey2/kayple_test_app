import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kayple_test/core/utils/error_handler.dart';

import 'presenter/post/screens/post_list_screen.dart';

void main() {
  runZonedGuarded(() async {
    FlutterError.onError = ErrorHandler.handleFlutterError;
    PlatformDispatcher.instance.onError =
        ErrorHandler.handlePlatformDispatcherError;

    runApp(const MyApp());
  }, ErrorHandler.handleUncaughtError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PostListScreen(),
    );
  }
}
