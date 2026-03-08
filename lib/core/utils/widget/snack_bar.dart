import 'package:digital_wallet/core/constants/app_constants.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void show({
    required String message,
    Color backgroundColor = AppColors.blackLite,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.regular(color: AppColors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction ?? () {},
              textColor: AppColors.white,
            )
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
    AppConstants.scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void success(String message) {
    show(message: message, backgroundColor: AppColors.green);
  }

  static void error(String message) {
    show(message: message, backgroundColor: AppColors.darkRed);
  }

  static void info(String message) {
    show(message: message, backgroundColor: AppColors.primaryColor);
  }

  static void warning(String message) {
    show(message: message, backgroundColor: AppColors.warningColor);
  }
}
