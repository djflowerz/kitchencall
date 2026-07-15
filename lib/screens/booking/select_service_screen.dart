import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_flow_provider.dart';
import 'booking_progress_bar.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

const _serviceIcons = {
  'Daily Meal': Icons.wb_sunny_outlined,
  'Special Occasion': Icons.celebration_outlined,
  'Meal Prep': Icons.kitchen_outlined,
  'Custom / Other': Icons.edit_note_outlined,
};

class SelectServiceScreen extends ConsumerWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final cook = draft.cook;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: cook == null
          ? const Center(child: Text('Please choose a cook first.'))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BookingProgressBar(step: 1, total: 7),
                  const SizedBox(height: 16),
                  Text('What type of service do you need?', style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text('Booking with ${cook.name}', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: AppConstants.serviceTypes.length,
                      itemBuilder: (context, i) {
                        final type = AppConstants.serviceTypes[i];
                        final selected = draft.serviceType == type;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => ref.read(bookingFlowProvider.notifier).setServiceType(type),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primaryGreenLight : context.surfaceColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: selected ? AppColors.primaryGreen : context.surfaceColors.border, width: selected ? 1.5 : 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(_serviceIcons[type], color: AppColors.primaryGreen),
                                  const SizedBox(width: 14),
                                  Expanded(child: Text(type, style: AppTextStyles.h3)),
                                  if (selected) const Icon(Icons.check_circle, color: AppColors.primaryGreen),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PrimaryButton(
                    label: 'Continue',
                    onPressed: draft.serviceType == null
                        ? null
                        : () => context.pushNamed('selectDateTime'),
                  ),
                ],
              ),
            ),
    );
  }
}
