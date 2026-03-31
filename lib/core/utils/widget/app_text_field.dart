import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final dynamic inputFormatters;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
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
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.prefixIcon,
    this.prefixText,
    this.prefixTextStyle,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.autofillHints,
    this.focusNode,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          inputFormatters: inputFormatters ?? [],
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
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            prefixStyle: prefixTextStyle ?? AppTextStyles.regular(),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade100,
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
