import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cook_provider.dart';

const _cuisineIcons = {
  'African': Icons.local_dining,
  'Swahili': Icons.set_meal,
  'Kenyan': Icons.rice_bowl,
  'Italian': Icons.local_pizza,
  'Indian': Icons.soup_kitchen,
  'Chinese': Icons.ramen_dining,
  'Vegan': Icons.eco,
  'Vegetarian': Icons.grass,
  'Healthy': Icons.favorite,
  'BBQ': Icons.outdoor_grill,
};

class ExploreTab extends ConsumerWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuisines = AppConstants.cuisines.where((c) => c != 'All').toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text('Explore', style: AppTextStyles.h2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Browse cooks by cuisine', style: AppTextStyles.bodySmall),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cuisines.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, i) {
                final cuisine = cuisines[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    ref.read(searchFiltersProvider.notifier).setCuisine(cuisine);
                    context.pushNamed('searchResults');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(_cuisineIcons[cuisine] ?? Icons.restaurant, color: AppColors.primaryGreen, size: 28),
                        Text(cuisine, style: AppTextStyles.h3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
