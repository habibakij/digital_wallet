// lib/core/app/app_bootstrap.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Handles all Flutter engine + system-level bootstrap tasks
/// before [runApp] is called. Keeps [main()] thin and readable.
class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    _lockToPortrait();
    _configureSystemUI();
  }

  static void _lockToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Transparent status bar with light icons to match the
  /// dark gradient found on the splash / login header.
  static void _configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }
}
