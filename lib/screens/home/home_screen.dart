import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/cook_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cook_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  String _selectedCategory = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final featuredAsync = ref.watch(featuredCooksProvider);
    final nearbyAsync = ref.watch(nearbyCooksProvider);
    final favorites = ref.watch(favoritesProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredCooksProvider);
          ref.invalidate(nearbyCooksProvider);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('👋 Good Evening, ${user?.fullName.split(' ').first ?? 'there'}', style: AppTextStyles.h3),
                        Text('What would you like today?', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pushNamed('notifications'),
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => context.pushNamed('search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: context.surfaceColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.surfaceColors.border),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: AppColors.textMuted),
                      SizedBox(width: 10),
                      Text('Search cooks, cuisines or meals', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: AppConstants.serviceCategories.map((c) {
                  return CategoryChip(
                    label: c,
                    selected: _selectedCategory == c,
                    onTap: () => setState(() => _selectedCategory = c),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: '⭐ Featured Cooks', onSeeAll: () => context.pushNamed('searchResults')),
            SizedBox(
              height: 232,
              child: featuredAsync.when(
                data: (cooks) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: cooks.length,
                  itemBuilder: (context, i) => CookCard(
                    cook: cooks[i],
                    isFavorite: favorites.contains(cooks[i].id),
                    onFavoriteToggle: () => ref.read(favoritesProvider.notifier).toggle(cooks[i].id),
                    onTap: () => context.pushNamed('cookProfile', pathParameters: {'cookId': cooks[i].id}),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Could not load cooks: $e')),
              ),
            ),
            const SizedBox(height: 12),
            SectionHeader(title: '📍 Nearby Cooks', onSeeAll: () => context.pushNamed('searchResults')),
            nearbyAsync.when(
              data: (cooks) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: cooks
                      .map((cook) => CookListTile(
                            cook: cook,
                            onTap: () => context.pushNamed('cookProfile', pathParameters: {'cookId': cook.id}),
                          ))
                      .toList(),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Could not load cooks: $e')),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.secondaryOrange, Color(0xFFFB923C)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('20% off your first booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                          Text('Use code WELCOME10 at checkout', style: TextStyle(color: Colors.white, fontSize: 12)),
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
    );
  }
}
