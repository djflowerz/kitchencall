import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_flow_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cook_provider.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class CookProfileScreen extends ConsumerWidget {
  const CookProfileScreen({super.key, required this.cookId});
  final String cookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cookAsync = ref.watch(cookByIdProvider(cookId));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: cookAsync.when(
        data: (cook) {
          if (cook == null) return const Center(child: Text('Cook not found'));
          final isFav = favorites.contains(cook.id);

          return DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                  actions: [
                    IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? AppColors.error : null),
                      onPressed: () => ref.read(favoritesProvider.notifier).toggle(cook.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () => Share.share(
                        'Check out ${cook.name} on KitchenCall — ${cook.cuisines.join(', ')} cuisine, '
                        '${cook.rating}★ (${cook.reviewCount} reviews). Book at kitchencall.app/cook/${cook.id}',
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(cook.photoUrl, fit: BoxFit.cover),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(90),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(cook.name, style: AppTextStyles.h2),
                              const SizedBox(width: 6),
                              if (cook.isVerified) const Icon(Icons.verified, color: AppColors.primaryGreen, size: 18),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 15, color: AppColors.starGold),
                              Text(' ${cook.rating} (${cook.reviewCount} reviews) · ', style: AppTextStyles.bodySmall),
                              Text('From ${AppConstants.currencySymbol} ${cook.startingPrice.toStringAsFixed(0)}', style: AppTextStyles.bodySmall),
                            ],
                          ),
                          const TabBar(
                            labelColor: AppColors.primaryGreen,
                            unselectedLabelColor: AppColors.textMuted,
                            indicatorColor: AppColors.primaryGreen,
                            tabs: [
                              Tab(text: 'About'),
                              Tab(text: 'Menu'),
                              Tab(text: 'Reviews'),
                              Tab(text: 'Gallery'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  _AboutTab(cook: cook),
                  _MenuTab(meals: cook.menu),
                  _ReviewsTab(reviews: cook.reviews, rating: cook.rating, count: cook.reviewCount),
                  _GalleryTab(urls: cook.galleryUrls),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: cookAsync.maybeWhen(
        data: (cook) => cook == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: () => context.pushNamed('chat', pathParameters: {'cookId': cook.id}, extra: cook.name),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Message'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: 'Book Now',
                          onPressed: () {
                            ref.read(bookingFlowProvider.notifier).startWithCook(cook);
                            context.pushNamed('selectService');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.cook});
  final dynamic cook;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biography', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(cook.bio.isEmpty ? 'No bio provided yet.' : cook.bio, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          Text('Cuisines', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: (cook.cuisines as List<String>)
                .map((c) => Chip(label: Text(c), backgroundColor: AppColors.primaryGreenLight))
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatTile(label: 'Experience', value: '${cook.yearsExperience} yrs'),
              _StatTile(label: 'Languages', value: (cook.languages as List<String>).join(', ')),
            ],
          ),
          const SizedBox(height: 20),
          Text('Verification', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          const _VerificationRow(label: 'ID Verified'),
          const _VerificationRow(label: 'Food Safety Certificate'),
          const _VerificationRow(label: 'Police Clearance'),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.h3),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _MenuTab extends StatelessWidget {
  const _MenuTab({required this.meals});
  final List meals;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return const Center(child: Text('No menu items yet.'));
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: meals.length,
      itemBuilder: (context, i) {
        final meal = meals[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: context.surfaceColors.divider),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(meal.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name, style: AppTextStyles.h3),
                    Text('${meal.prepTimeMinutes} mins prep', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Text('${AppConstants.currencySymbol} ${meal.price.toStringAsFixed(0)}', style: AppTextStyles.price),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.reviews, required this.rating, required this.count});
  final List reviews;
  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Text(rating.toStringAsFixed(1), style: AppTextStyles.h1),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(5, (i) => const Icon(Icons.star, size: 16, color: AppColors.starGold))),
                Text('$count reviews', style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
        const Divider(height: 32),
        if (reviews.isEmpty) const Text('No reviews yet.'),
        ...reviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: AppColors.primaryGreenLight, child: Text(r.customerName[0])),
                      const SizedBox(width: 10),
                      Text(r.customerName, style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(children: List.generate(5, (i) => Icon(Icons.star, size: 13, color: i < r.rating.round() ? AppColors.starGold : context.surfaceColors.border))),
                  const SizedBox(height: 6),
                  Text(r.comment, style: AppTextStyles.bodyMedium),
                ],
              ),
            )),
      ],
    );
  }
}

class _GalleryTab extends StatelessWidget {
  const _GalleryTab({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const Center(child: Text('No photos yet.'));
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: urls.length,
      itemBuilder: (context, i) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(urls[i], fit: BoxFit.cover),
      ),
    );
  }
}
