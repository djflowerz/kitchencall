import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_launcher.dart';

const _faqs = [
  ('How do I book a cook?', 'Search or browse cooks, open their profile, tap "Book Now" and follow the steps to choose a service, date, menu and payment method.'),
  ('Can I cancel a booking?', 'Yes — open the booking under "My Bookings" and tap "Cancel Booking". Cancellation fees may apply depending on how close it is to the scheduled time.'),
  ('How does the ingredients option work?', 'You can supply your own ingredients, have the cook buy them and reimburse them, or have KitchenCall deliver them for an additional fee.'),
  ('What if I have food allergies?', 'Add them under Profile > Dietary Preferences, or note them in "Special Instructions" during booking — your cook will see them before they arrive.'),
];

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.call_outlined,
                  label: 'Call Us',
                  onTap: () => AppLauncher.call(context, '+254700000000'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ContactCard(
                  icon: Icons.email_outlined,
                  label: 'Email Us',
                  onTap: () => AppLauncher.email(context, 'support@kitchencall.app'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ContactCard(
            icon: Icons.report_gmailerrorred_outlined,
            label: 'Report an Issue',
            fullWidth: true,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (sheetContext) => Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Report an Issue', style: AppTextStyles.h2),
                    const SizedBox(height: 12),
                    const TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Describe what went wrong...')),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thanks — our support team will follow up shortly.')),
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Frequently Asked Questions', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          ..._faqs.map((faq) => ExpansionTile(
                title: Text(faq.$1, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [Align(alignment: Alignment.centerLeft, child: Text(faq.$2, style: AppTextStyles.bodySmall))],
              )),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.icon, required this.label, required this.onTap, this.fullWidth = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(color: AppColors.primaryGreenLight, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
