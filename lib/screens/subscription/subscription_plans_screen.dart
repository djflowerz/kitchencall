import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class _Plan {
  final String name;
  final String price;
  final String period;
  final List<String> benefits;
  final bool bestValue;
  const _Plan(this.name, this.price, this.period, this.benefits, {this.bestValue = false});
}

const _plans = [
  _Plan('Weekly', 'KES 1,800', '/week', ['5 meals per week', 'Choose any cook', 'Free rescheduling']),
  _Plan('Monthly', 'KES 6,000', '/month', ['20 meals per month', 'Priority booking', 'Save 15% vs weekly'], bestValue: true),
  _Plan('Quarterly', 'KES 16,000', '/3 months', ['60 meals', 'Dedicated cook option', 'Save 25% vs weekly']),
];

void _confirmSubscribe(BuildContext context, _Plan plan) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Confirm Subscription'),
      content: Text('Subscribe to the ${plan.name} plan for ${plan.price}${plan.period}? '
          'You\'ll be charged via your default payment method.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Subscribed to the ${plan.name} plan!')),
            );
            // TODO: create a real subscription record via a
            // SubscriptionRepository once the backend is connected,
            // and route to a payment confirmation step if needed.
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Save more with a meal plan', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          Text('Get consistent home-cooked meals at a lower price.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          ..._plans.map((plan) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: plan.bestValue ? AppColors.primaryGreen : context.surfaceColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: plan.bestValue ? AppColors.primaryGreen : context.surfaceColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(plan.name, style: AppTextStyles.h2.copyWith(color: plan.bestValue ? Colors.white : AppColors.textDark)),
                        if (plan.bestValue)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.secondaryOrange, borderRadius: BorderRadius.circular(20)),
                            child: const Text('Best Value', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(plan.price, style: AppTextStyles.h1.copyWith(color: plan.bestValue ? Colors.white : AppColors.primaryGreen, fontSize: 26)),
                        Text(plan.period, style: AppTextStyles.bodyMedium.copyWith(color: plan.bestValue ? Colors.white70 : AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...plan.benefits.map((b) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: plan.bestValue ? Colors.white : AppColors.primaryGreen),
                              const SizedBox(width: 8),
                              Text(b, style: AppTextStyles.bodyMedium.copyWith(color: plan.bestValue ? Colors.white : AppColors.textDark)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Subscribe Now',
                      backgroundColor: plan.bestValue ? Colors.white : null,
                      onPressed: () => _confirmSubscribe(context, plan),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
