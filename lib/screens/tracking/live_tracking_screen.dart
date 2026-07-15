import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_launcher.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

/// Real implementation should render a `GoogleMap` widget with the
/// cook's live coordinates streamed from Firestore/your backend and
/// animate the marker as location updates arrive. This screen wires
/// up the surrounding UI (timeline, chat/call actions) around that map.
class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Track Your Cook')),
      body: bookingsAsync.when(
        data: (bookings) {
          final booking = bookings.where((b) => b.id == bookingId).firstOrNull;
          if (booking == null) {
            return const Center(child: Text('Booking not found.'));
          }
          return Column(
            children: [
              // Map placeholder — swap for google_maps_flutter's GoogleMap()
              // once API keys are configured for this project.
              Container(
                height: 260,
                width: double.infinity,
                color: AppColors.primaryGreenLight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.map_outlined, size: 64, color: AppColors.primaryGreen),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(booking.cookPhotoUrl), radius: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${booking.cookName} is ${booking.trackingStage.label.toLowerCase()}', style: AppTextStyles.h3),
                                  const Text('Arriving in ~12 mins', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Progress', style: AppTextStyles.h3),
                      const SizedBox(height: 16),
                      ...TrackingStage.values.map((stage) {
                        final reached = stage.index <= booking.trackingStage.index;
                        final isCurrent = stage == booking.trackingStage;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: reached ? AppColors.primaryGreen : context.surfaceColors.divider,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  reached ? Icons.check : Icons.circle,
                                  size: reached ? 16 : 8,
                                  color: reached ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                stage.label,
                                style: isCurrent
                                    ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryGreen)
                                    : AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => AppLauncher.call(context, '+254712345678'),
                          icon: const Icon(Icons.call_outlined, size: 18),
                          label: const Text('Call'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.pushNamed('chat', pathParameters: {'cookId': booking.cookId}, extra: booking.cookName),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Message'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
