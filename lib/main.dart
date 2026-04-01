import 'dart:async';

import 'package:digital_wallet/app.dart';
import 'package:flutter/material.dart';

import '/app_bootstrap.dart';
import 'core/exception_handler/central_error_screen.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  await configureDependencies();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return customErrorBuilder(details: details);
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    //FirebaseCrashlytics.instance.recordFlutterError(details); // example
  };
  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) {
      debugPrint('Zone error: $error\n$stack');
    },
  );
}

Widget customErrorBuilder({FlutterErrorDetails? details}) {
  return CentralErrorScreen(details: details);
}
