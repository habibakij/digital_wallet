import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final IconData? prefixIcon;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height = 48,
    this.borderRadius = 8,
    this.elevation = 0.5,
    this.backgroundColor,
    this.textStyle,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          padding: padding,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          size: 22,
                          color: AppColors.white,
                        )
                      : const SizedBox.shrink(),
                  if (prefixIcon != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: textStyle ?? AppTextStyles.title(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
