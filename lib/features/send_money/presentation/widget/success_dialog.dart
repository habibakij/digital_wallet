import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/send_money/domain/entities/transfer_entity.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final TransferEntity transfer;
  final VoidCallback onDone;
  final VoidCallback onSendAnother;

  const SuccessDialog({super.key, required this.transfer, required this.onDone, required this.onSendAnother});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accentColor,
                size: 52,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transfer Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have successfully sent',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(transfer.amount),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'to ${transfer.receiverName}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // Details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Reference No',
                    value: transfer.referenceNumber,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Account',
                    value: transfer.receiverAccount,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'New Balance',
                    value: CurrencyFormatter.formatSimple(transfer.newBalance),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Date & Time',
                    value: DateFormatter.formatTransaction(transfer.timestamp),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onSendAnother,
              child: const Text('Send Another', style: TextStyle(color: AppColors.primaryColor)),
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
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
