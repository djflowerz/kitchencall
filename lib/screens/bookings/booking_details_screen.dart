import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: bookingsAsync.when(
        data: (bookings) {
          final booking = bookings.where((b) => b.id == bookingId).toList();
          if (booking.isEmpty) return const Center(child: Text('Booking not found.'));
          final b = booking.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(b.cookPhotoUrl), radius: 26),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.cookName, style: AppTextStyles.h2),
                        Text('Booking #${b.id}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _DetailCard(children: [
                  _Row('Service', b.serviceType),
                  _Row('Meal', b.mealSlot),
                  _Row('Date', DateFormat('EEEE, d MMM yyyy').format(b.date)),
                  _Row('Time', b.timeSlot),
                  _Row('People', '${b.numberOfPeople}'),
                  _Row('Location', b.location),
                ]),
                const SizedBox(height: 16),
                _DetailCard(children: [
                  for (final meal in b.selectedMeals) _Row(meal.name, '${AppConstants.currencySymbol} ${meal.price.toStringAsFixed(0)}'),
                  const Divider(),
                  _Row('Total', '${AppConstants.currencySymbol} ${b.total.toStringAsFixed(0)}', bold: true),
                ]),
                if (b.specialInstructions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Special Instructions', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text(b.specialInstructions, style: AppTextStyles.bodyMedium),
                ],
                const SizedBox(height: 24),
                if (b.status == BookingStatus.upcoming || b.status == BookingStatus.active)
                  PrimaryButton(
                    label: b.status == BookingStatus.active ? 'Track Booking' : 'Reschedule',
                    onPressed: () {
                      if (b.status == BookingStatus.active) {
                        context.pushNamed('liveTracking', pathParameters: {'bookingId': b.id});
                      }
                    },
                  ),
                if (b.status == BookingStatus.upcoming) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      await ref.read(bookingActionsProvider).cancel(b.id);
                      if (context.mounted) context.pop();
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    child: const Text('Cancel Booking'),
                  ),
                ],
                if (b.status == BookingStatus.completed)
                  PrimaryButton(
                    label: 'Rate Cook',
                    onPressed: () => context.pushNamed('ratingReview', pathParameters: {'bookingId': b.id}),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.surfaceColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.surfaceColors.divider)),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value, style: bold ? AppTextStyles.h3 : AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
