import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/cook_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Cooks')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (v) => ref.read(searchFiltersProvider.notifier).setQuery(v),
              decoration: const InputDecoration(
                hintText: 'Search by name, cuisine or dish',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Text('Cuisines', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.cuisines.map((c) {
                return CategoryChip(
                  label: c,
                  selected: filters.cuisine == c,
                  onTap: () => ref.read(searchFiltersProvider.notifier).setCuisine(c),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Max price: ${AppConstants.currencySymbol} ${filters.maxPrice.toStringAsFixed(0)}', style: AppTextStyles.h3),
            Slider(
              value: filters.maxPrice,
              min: 0,
              max: 5000,
              divisions: 20,
              activeColor: AppColors.primaryGreen,
              onChanged: (v) => ref.read(searchFiltersProvider.notifier).setMaxPrice(v),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Search',
              onPressed: () => context.pushNamed('searchResults'),
            ),
          ],
        ),
      ),
    );
  }
}
