import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cook_card.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cook_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final cooksAsync = ref.watch(allCooksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: cooksAsync.when(
        data: (cooks) {
          final favCooks = cooks.where((c) => favorites.contains(c.id)).toList();
          if (favCooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 56, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text('No favorite cooks yet', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text('Tap the heart on a cook profile to save them here', style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: favCooks.length,
            itemBuilder: (context, i) => CookListTile(
              cook: favCooks[i],
              onTap: () => context.pushNamed('cookProfile', pathParameters: {'cookId': favCooks[i].id}),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
