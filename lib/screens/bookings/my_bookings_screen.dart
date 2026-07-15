import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class MyBookingsTab extends ConsumerStatefulWidget {
  const MyBookingsTab({super.key});

  @override
  ConsumerState<MyBookingsTab> createState() => _MyBookingsTabState();
}

class _MyBookingsTabState extends ConsumerState<MyBookingsTab> {
  BookingStatus _filter = BookingStatus.upcoming;

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Align(alignment: Alignment.centerLeft, child: Text('My Bookings', style: AppTextStyles.h2)),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: BookingStatus.values.map((status) {
                return CategoryChip(
                  label: _label(status),
                  selected: _filter == status,
                  onTap: () => setState(() => _filter = status),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: bookingsAsync.when(
              data: (bookings) {
                final filtered = bookings.where((b) => b.status == _filter).toList();
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 56, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('No ${_label(_filter).toLowerCase()} bookings yet', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 6),
                        TextButton(onPressed: () => context.goNamed('home'), child: const Text('Find a cook')),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => _BookingCard(booking: filtered[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  String _label(BookingStatus s) {
    switch (s) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});
  final BookingModel booking;

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return AppColors.statusUpcoming;
      case BookingStatus.active:
        return AppColors.statusInProgress;
      case BookingStatus.completed:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.surfaceColors.divider),
      ),
      child: InkWell(
        onTap: () => context.pushNamed('bookingDetails', pathParameters: {'bookingId': booking.id}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(booking.cookPhotoUrl), radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.cookName, style: AppTextStyles.h3),
                      Text('${booking.serviceType} • ${booking.mealSlot}', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                StatusBadge(label: _statusLabel, color: _statusColor),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(DateFormat('d MMM yyyy').format(booking.date), style: AppTextStyles.bodySmall),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(booking.timeSlot, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppConstants.currencySymbol} ${booking.total.toStringAsFixed(0)}', style: AppTextStyles.price),
                if (booking.status == BookingStatus.active)
                  TextButton.icon(
                    onPressed: () => context.pushNamed('liveTracking', pathParameters: {'bookingId': booking.id}),
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text('Track'),
                  )
                else if (booking.status == BookingStatus.completed)
                  TextButton(
                    onPressed: () => context.pushNamed('ratingReview', pathParameters: {'bookingId': booking.id}),
                    child: const Text('Rate Cook'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}
