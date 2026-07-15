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

class ChooseMenuScreen extends ConsumerWidget {
  const ChooseMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final cook = draft.cook;
    final notifier = ref.read(bookingFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Menu')),
      body: cook == null
          ? const SizedBox()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: BookingProgressBar(step: 3, total: 7),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Select your preferred dishes', style: AppTextStyles.h3)),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: cook.menu.length,
                    itemBuilder: (context, i) {
                      final meal = cook.menu[i];
                      final selected = draft.selectedMeals.any((m) => m.id == meal.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primaryGreenLight : context.surfaceColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: selected ? AppColors.primaryGreen : context.surfaceColors.divider),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(meal.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal.name, style: AppTextStyles.h3),
                                  Text('${AppConstants.currencySymbol} ${meal.price.toStringAsFixed(0)}', style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: selected,
                              activeColor: AppColors.primaryGreen,
                              onChanged: (_) => notifier.toggleMeal(meal),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    label: 'Continue (${draft.selectedMeals.length})',
                    onPressed: draft.selectedMeals.isEmpty ? null : () => context.pushNamed('ingredients'),
                  ),
                ),
              ],
            ),
    );
  }
}
