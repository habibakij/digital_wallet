import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // brand colors
  static const Color primaryColor = Color(0xFF1A237E);
  static const Color primaryLiteColor = Color(0xFF283593);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFF00E676);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  // semantic colors
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardGradiantColor1 = Color(0xFF1565C0);
  static const Color cardGradiantColor2 = Color(0xFF0D47A1);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFEF5350);
  // additional colors
  static const Color white = Color(0XFFffffff);
  static const Color whiteLiteColor = Color(0XFFf2f2f2);
  static const Color black = Color(0XFF000000);
  static const Color blackTin = Color(0XFF0d0d0d);
  static const Color blackLite = Color(0xFF575353);
  static const Color red = Color(0XFFE53935);
  static const Color darkRed = Color(0XFFb32400);
  static const Color grey = Color(0XFFaaaaaa);
  static const Color greyLite = Color(0XFF999999);
  static const Color greyShade100 = Color(0xFFF5F5F5);
  static const Color greyShade200 = Color(0xFFEEEEEE);
  static const Color greyShade300 = Color(0xFFE0E0E0);
  static const Color orangeColor = Color(0XFFff9900);
  static const Color green = Color(0XFF009933);
  static const Color greenLite = Color(0XFF99ffbb);
  static const Color yellow = Color(0XFFF5A905);
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLiteColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardGradiantColor1, cardGradiantColor2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
