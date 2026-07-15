import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_flow_provider.dart';
import 'booking_progress_bar.dart';

class BookingSummaryScreen extends ConsumerWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final cook = draft.cook;
    if (cook == null) return const Scaffold(body: SizedBox());

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Summary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingProgressBar(step: 5, total: 7),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _SummaryTile(label: 'Cook', value: cook.name),
                  _SummaryTile(label: 'Service', value: draft.serviceType ?? '-'),
                  _SummaryTile(label: 'Meal', value: draft.mealSlot),
                  _SummaryTile(label: 'Date', value: draft.date != null ? DateFormat('d MMM yyyy').format(draft.date!) : '-'),
                  _SummaryTile(label: 'Time', value: draft.timeSlot ?? '-'),
                  _SummaryTile(label: 'People', value: '${draft.numberOfPeople}'),
                  _SummaryTile(label: 'Items', value: draft.selectedMeals.map((m) => m.name).join(', ')),
                  _SummaryTile(label: 'Ingredients', value: draft.ingredientOption),
                  if (draft.wantsDelivery) const _SummaryTile(label: 'Delivery', value: 'Yes'),
                  const Divider(height: 32),
                  _SummaryTile(label: 'Meals subtotal', value: '${AppConstants.currencySymbol} ${draft.mealsSubtotal.toStringAsFixed(0)}'),
                  _SummaryTile(label: 'Travel fee', value: '${AppConstants.currencySymbol} ${draft.travelFee.toStringAsFixed(0)}'),
                  _SummaryTile(label: 'Service fee', value: '${AppConstants.currencySymbol} ${draft.serviceFee.toStringAsFixed(0)}'),
                  if (draft.ingredientsCost > 0)
                    _SummaryTile(label: 'Ingredients cost', value: '${AppConstants.currencySymbol} ${draft.ingredientsCost.toStringAsFixed(0)}'),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Estimate', style: AppTextStyles.h3),
                      Text('${AppConstants.currencySymbol} ${draft.total.toStringAsFixed(0)}', style: AppTextStyles.h2.copyWith(color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            PrimaryButton(label: 'Continue to Payment', onPressed: () => context.pushNamed('payment')),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
