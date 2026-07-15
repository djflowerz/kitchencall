import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class _PaymentMethod {
  final IconData icon;
  final String label;
  final String detail;
  final bool isDefault;
  const _PaymentMethod(this.icon, this.label, this.detail, this.isDefault);
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<_PaymentMethod> _methods = [
    const _PaymentMethod(Icons.phone_android, 'M-Pesa', '+254 712 345 678', true),
    const _PaymentMethod(Icons.credit_card, 'Visa', '**** **** **** 4821', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ..._methods.map((m) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: context.surfaceColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.surfaceColors.divider)),
                child: Row(
                  children: [
                    Icon(m.icon, color: AppColors.primaryGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(m.label, style: AppTextStyles.h3),
                            if (m.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.primaryGreenLight, borderRadius: BorderRadius.circular(10)),
                                child: Text('Default', style: AppTextStyles.caption.copyWith(color: AppColors.primaryGreen)),
                              ),
                            ],
                          ]),
                          Text(m.detail, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => setState(() => _methods.remove(m)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => _methods.add(const _PaymentMethod(Icons.credit_card, 'New Card', '**** **** **** 0000', false)));
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Method'),
          ),
        ],
      ),
    );
  }
}
