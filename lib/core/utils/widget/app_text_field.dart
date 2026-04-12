import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? prefixText;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;
  final bool needToValidator;
  final bool enable;
  final dynamic inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? prefixTextStyle;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;
  final EdgeInsetsGeometry contentPadding;

  const CommonTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.prefixText,
    this.autofillHints,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.needToValidator = true,
    this.enable = true,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.prefixTextStyle,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return errorText ?? 'This field is required';
    }
    return null;
  }

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
          inputFormatters: inputFormatters ?? [],
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          //validator: needToValidator ? validator ?? _defaultValidator : null,
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
          enabled: enable,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ?? AppTextStyles.hintStyle(),
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            prefixStyle: prefixTextStyle ?? AppTextStyles.regular(),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.greyShade100,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            counterText: "",
            helperText: "",
            errorText: errorText,
            errorMaxLines: 1,
            helperStyle: AppTextStyles.regular(),
            errorStyle: AppTextStyles.errorStyle(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.greyShade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            errorBorder: errorText != null && errorText!.isNotEmpty
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.red, width: 1),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.greyShade300, width: 1),
                  ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
