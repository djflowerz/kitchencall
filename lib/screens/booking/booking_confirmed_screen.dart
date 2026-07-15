import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/booking_model.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key, required this.booking});
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primaryGreenLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 64),
              ),
              const SizedBox(height: 24),
              Text('Booking Confirmed!', style: AppTextStyles.h1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Your booking with ${booking.cookName} has been confirmed.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(color: context.surfaceColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.surfaceColors.divider)),
                child: Column(
                  children: [
                    _row('Booking ID', booking.id),
                    _row('Date & Time', '${booking.timeSlot}'),
                    _row('Total', 'KES ${booking.total.toStringAsFixed(0)}'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Track Booking',
                onPressed: () => context.goNamed('liveTracking', pathParameters: {'bookingId': booking.id}),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.goNamed('home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
