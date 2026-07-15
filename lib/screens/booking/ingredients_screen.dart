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

class IngredientsScreen extends ConsumerStatefulWidget {
  const IngredientsScreen({super.key});

  @override
  ConsumerState<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends ConsumerState<IngredientsScreen> {
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingFlowProvider);
    final notifier = ref.read(bookingFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingProgressBar(step: 4, total: 7),
            const SizedBox(height: 16),
            Text('How would you like to handle ingredients?', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            ...AppConstants.ingredientOptions.map((option) {
              final selected = draft.ingredientOption == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => notifier.setIngredientOption(option),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryGreenLight : context.surfaceColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.primaryGreen : context.surfaceColors.divider),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: draft.ingredientOption,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (v) => notifier.setIngredientOption(v!),
                        ),
                        Expanded(child: Text(option, style: AppTextStyles.bodyMedium)),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I need delivery'),
              subtitle: const Text("Cook prepares the meal, a driver brings it to you", style: TextStyle(fontSize: 12)),
              value: draft.wantsDelivery,
              activeColor: AppColors.primaryGreen,
              onChanged: notifier.setWantsDelivery,
            ),
            const SizedBox(height: 12),
            Text('Special instructions (optional)', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              onChanged: notifier.setInstructions,
              decoration: const InputDecoration(hintText: 'Allergies, spice level, anything else the cook should know...'),
            ),
            const Spacer(),
            PrimaryButton(label: 'Continue', onPressed: () => context.pushNamed('bookingSummary')),
          ],
        ),
      ),
    );
  }
}
