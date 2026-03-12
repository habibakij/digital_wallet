import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  /// ---------- Titles ----------
  static TextStyle title({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Sub Title ----------
  static TextStyle subTitle({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Regular ----------
  static TextStyle regular({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Hint / Input ----------
  static TextStyle hintStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.greyLite,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Price / Discount ----------
  static TextStyle discountStrikeStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration decoration = TextDecoration.lineThrough,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.greyLite,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Buttons ----------
  static TextStyle buttonStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.white,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }

  /// ---------- Error ----------
  static TextStyle errorStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double letterSpacing = 0,
    double height = 1.2,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.darkRed,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration ?? TextDecoration.none,
      fontStyle: fontStyle,
    );
  }
}
