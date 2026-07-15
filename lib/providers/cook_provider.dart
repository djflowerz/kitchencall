import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/cook_repository.dart';
import '../models/cook_model.dart';

final cookRepositoryProvider = Provider<CookRepository>((ref) => MockCookRepository());

final allCooksProvider = FutureProvider<List<CookModel>>((ref) {
  return ref.watch(cookRepositoryProvider).getCooks();
});

final featuredCooksProvider = FutureProvider<List<CookModel>>((ref) {
  return ref.watch(cookRepositoryProvider).getFeaturedCooks();
});

final nearbyCooksProvider = FutureProvider<List<CookModel>>((ref) {
  return ref.watch(cookRepositoryProvider).getNearbyCooks();
});

final cookByIdProvider = FutureProvider.family<CookModel?, String>((ref, id) {
  return ref.watch(cookRepositoryProvider).getCookById(id);
});

/// Search query + cuisine filter state, consumed by the search screens.
class SearchFilters {
  final String query;
  final String cuisine;
  final double maxPrice;

  const SearchFilters({this.query = '', this.cuisine = 'All', this.maxPrice = 5000});

  SearchFilters copyWith({String? query, String? cuisine, double? maxPrice}) {
    return SearchFilters(
      query: query ?? this.query,
      cuisine: cuisine ?? this.cuisine,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

class SearchFiltersController extends StateNotifier<SearchFilters> {
  SearchFiltersController() : super(const SearchFilters());

  void setQuery(String q) => state = state.copyWith(query: q);
  void setCuisine(String c) => state = state.copyWith(cuisine: c);
  void setMaxPrice(double p) => state = state.copyWith(maxPrice: p);
  void reset() => state = const SearchFilters();
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersController, SearchFilters>((ref) => SearchFiltersController());

final searchResultsProvider = FutureProvider<List<CookModel>>((ref) {
  final filters = ref.watch(searchFiltersProvider);
  return ref.watch(cookRepositoryProvider).searchCooks(
        query: filters.query,
        cuisine: filters.cuisine,
      );
});
