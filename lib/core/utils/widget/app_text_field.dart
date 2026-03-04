import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final Function(String)? onChanged;
  final Function()? onTap;

  const CommonTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
    this.focusNode,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        labelText != null
            ? Text(
                labelText ?? "",
                style: labelStyle ?? AppTextStyles.regular(),
              )
            : const SizedBox.shrink(),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          autofillHints: autofillHints,
          style: inputTextStyle ?? AppTextStyles.regular(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          focusNode: focusNode,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          onChanged: onChanged,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ?? AppTextStyles.hintStyle(),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: AppColors.textSecondary) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: contentPadding,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            counterText: "",
            helperText: "",
            helperStyle: AppTextStyles.regular(),
            errorStyle: AppTextStyles.errorStyle(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
