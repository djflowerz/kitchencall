import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void _showAmountSheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String confirmLabel,
  required void Function(double amount) onConfirm,
}) {
  final controller = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h2),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (KES)', prefixText: 'KES '),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [500, 1000, 2000, 5000]
                  .map((v) => ActionChip(label: Text('$v'), onPressed: () => controller.text = '$v'))
                  .toList(),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: confirmLabel,
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount == null || amount <= 0) {
                  _showSnack(sheetContext, 'Enter a valid amount');
                  return;
                }
                Navigator.of(sheetContext).pop();
                onConfirm(amount);
              },
            ),
          ],
        ),
      );
    },
  );
}

class _Transaction {
  final String label;
  final double amount;
  final String date;
  final bool isCredit;
  const _Transaction(this.label, this.amount, this.date, this.isCredit);
}

const _transactions = [
  _Transaction('Payment to Chef Amina', -1400, '15 May 2024', false),
  _Transaction('Top up via M-Pesa', 3000, '10 May 2024', true),
  _Transaction('Payment to Chef David', -1200, '5 May 2024', false),
];

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.greenGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wallet Balance', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text(
                  '${AppConstants.currencySymbol} ${(user?.walletBalance ?? 0).toStringAsFixed(0)}',
                  style: AppTextStyles.h1.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Add Money',
                        backgroundColor: Colors.white,
                        onPressed: () => _showAmountSheet(
                          context,
                          ref,
                          title: 'Add Money',
                          confirmLabel: 'Top Up',
                          onConfirm: (amount) {
                            ref.read(authControllerProvider.notifier).topUpWallet(amount);
                            _showSnack(context, 'Added ${AppConstants.currencySymbol} ${amount.toStringAsFixed(0)} to your wallet');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showAmountSheet(
                          context,
                          ref,
                          title: 'Withdraw',
                          confirmLabel: 'Withdraw',
                          onConfirm: (amount) {
                            final success = ref.read(authControllerProvider.notifier).withdrawFromWallet(amount);
                            _showSnack(
                              context,
                              success
                                  ? 'Withdrew ${AppConstants.currencySymbol} ${amount.toStringAsFixed(0)}'
                                  : 'Insufficient wallet balance',
                            );
                          },
                        ),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                        child: const Text('Withdraw'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Transaction History', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          ..._transactions.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: context.surfaceColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.surfaceColors.divider)),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: (t.isCredit ? AppColors.primaryGreen : AppColors.error).withValues(alpha: 0.12),
                      child: Icon(t.isCredit ? Icons.arrow_downward : Icons.arrow_upward, size: 16, color: t.isCredit ? AppColors.primaryGreen : AppColors.error),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.label, style: AppTextStyles.bodyMedium),
                          Text(t.date, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Text(
                      '${t.isCredit ? '+' : ''}${AppConstants.currencySymbol} ${t.amount.abs().toStringAsFixed(0)}',
                      style: AppTextStyles.bodyMedium.copyWith(color: t.isCredit ? AppColors.primaryGreen : AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
