import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_flow_provider.dart';
import '../../providers/booking_provider.dart';
import 'booking_progress_bar.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

const _paymentIcons = {
  'M-Pesa': Icons.phone_android,
  'Card Payment': Icons.credit_card,
  'Wallet Balance': Icons.account_balance_wallet_outlined,
  'Pay Later': Icons.schedule,
};

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _method = 'M-Pesa';
  bool _processing = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    // TODO: integrate real M-Pesa STK Push / card processor here.
    // On success, create the booking record:
    final booking = await ref.read(bookingActionsProvider).confirmBooking();
    if (mounted) context.goNamed('bookingConfirmed', extra: booking);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingFlowProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingProgressBar(step: 6, total: 7),
            const SizedBox(height: 20),
            Text('Total Amount', style: AppTextStyles.bodyMedium),
            Text('${AppConstants.currencySymbol} ${draft.total.toStringAsFixed(0)}', style: AppTextStyles.h1.copyWith(color: AppColors.primaryGreen)),
            const SizedBox(height: 24),
            Text('Select Payment Method', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            ...AppConstants.paymentMethods.map((method) {
              final selected = _method == method;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _method = method),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryGreenLight : context.surfaceColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.primaryGreen : context.surfaceColors.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(_paymentIcons[method], color: AppColors.primaryGreen),
                        const SizedBox(width: 12),
                        Expanded(child: Text(method, style: AppTextStyles.bodyMedium)),
                        Radio<String>(
                          value: method,
                          groupValue: _method,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (v) => setState(() => _method = v!),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Text('Secured by industry-standard encryption', style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Pay ${AppConstants.currencySymbol} ${draft.total.toStringAsFixed(0)}',
              isLoading: _processing,
              onPressed: _pay,
            ),
          ],
        ),
      ),
    );
  }
}
