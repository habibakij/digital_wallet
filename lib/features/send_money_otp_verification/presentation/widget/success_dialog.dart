import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final SendMoneyEntity entity;
  final VoidCallback onDone;
  final VoidCallback onSendAnother;

  const SuccessDialog({super.key, required this.entity, required this.onDone, required this.onSendAnother});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.accentColor, size: 52),
            ),
            const SizedBox(height: 20),
            Text(
              'Transfer Successful!',
              style: AppTextStyles.title(color: AppColors.primaryColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'You have successfully sent',
              style: AppTextStyles.regular(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(entity.amount),
              style: AppTextStyles.title(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'to ${entity.receiverName}',
              style: AppTextStyles.title(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteLiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 8.0,
                children: [
                  _DetailRow(
                    label: 'Reference No',
                    value: entity.referenceNumber,
                  ),
                  _DetailRow(
                    label: 'Account',
                    value: entity.receiverAccount,
                  ),
                  _DetailRow(
                    label: 'New Balance',
                    value: CurrencyFormatter.formatSimple(entity.newBalance),
                  ),
                  _DetailRow(
                    label: 'Date & Time',
                    value: DateFormatter.formatTransaction(entity.timestamp),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              title: 'Done',
              onPressed: onDone,
              textStyle: AppTextStyles.buttonStyle(),
              height: 44,
              borderRadius: 14,
            ),
            const SizedBox(height: 12),
            AppButton(
              title: 'Send Another',
              onPressed: onSendAnother,
              backgroundColor: AppColors.white70,
              textStyle: AppTextStyles.buttonStyle(color: AppColors.textPrimary),
              height: 44,
              borderRadius: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
