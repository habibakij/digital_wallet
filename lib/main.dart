import 'package:digital_wallet/app.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '/app_bootstrap.dart';
import 'core/exception_handler/central_error_screen.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  await configureDependencies(Environment.dev);
  runApp(const App());
}

Widget _customErrorBuilder({FlutterErrorDetails? details}) {
  return CentralErrorScreen(details: details);
}
