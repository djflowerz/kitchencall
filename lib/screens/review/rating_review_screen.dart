import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_provider.dart';

class RatingReviewScreen extends ConsumerStatefulWidget {
  const RatingReviewScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends ConsumerState<RatingReviewScreen> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Experience')),
      body: bookingsAsync.when(
        data: (bookings) {
          final booking = bookings.where((b) => b.id == widget.bookingId).toList();
          final cookName = booking.isNotEmpty ? booking.first.cookName : 'your cook';

          if (_submitted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 64, color: AppColors.secondaryOrange),
                    const SizedBox(height: 16),
                    Text('Thank you for your feedback!', style: AppTextStyles.h2, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    PrimaryButton(label: 'Back to Bookings', onPressed: () => context.pop()),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How was your experience with $cookName?', style: AppTextStyles.h2),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final filled = i < _rating;
                      return IconButton(
                        onPressed: () => setState(() => _rating = i + 1),
                        icon: Icon(filled ? Icons.star : Icons.star_border, color: AppColors.starGold, size: 36),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Write a review (optional)', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Share your experience...'),
                ),
                const Spacer(),
                PrimaryButton(label: 'Submit Review', onPressed: () => setState(() => _submitted = true)),
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
