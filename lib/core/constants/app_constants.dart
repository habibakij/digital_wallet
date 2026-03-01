import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // API
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Secure Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String pinKey = 'wallet_pin';

  // Transaction
  static const double minTransactionAmount = 0.01;
  static const double maxTransactionAmount = 50000.0;
  static const int transactionPageSize = 20;

  // Retry
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 1000; // ms

  // Token
  static const int tokenRefreshBufferSeconds = 60;
}
