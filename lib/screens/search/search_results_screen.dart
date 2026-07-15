import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cook_card.dart';
import '../../providers/cook_provider.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(filters.cuisine == 'All' ? 'All Cooks' : '${filters.cuisine} Cooks')),
      body: resultsAsync.when(
        data: (cooks) {
          if (cooks.isEmpty) {
            return const Center(child: Text('No cooks found. Try a different filter.'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text('${cooks.length} cooks found', style: AppTextStyles.bodyMedium),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: cooks.length,
                  itemBuilder: (context, i) => CookListTile(
                    cook: cooks[i],
                    onTap: () => context.pushNamed('cookProfile', pathParameters: {'cookId': cooks[i].id}),
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
