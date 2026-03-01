import 'package:digital_wallet/app.dart';
import 'package:flutter/material.dart';
import 'injection/injection.dart';
import '/app_bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  await configureDependencies();
  runApp(const App());
}
