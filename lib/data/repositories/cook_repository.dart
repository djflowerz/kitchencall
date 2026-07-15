import '../../models/cook_model.dart';
import '../mock_data.dart';

/// Contract the UI depends on. Implement [FirestoreCookRepository]
/// with the same shape when you're ready to go live, and swap the
/// provider binding in `providers/cook_provider.dart` — no screen
/// code needs to change.
abstract class CookRepository {
  Future<List<CookModel>> getCooks();
  Future<List<CookModel>> searchCooks({String? query, String? cuisine});
  Future<CookModel?> getCookById(String id);
  Future<List<CookModel>> getFeaturedCooks();
  Future<List<CookModel>> getNearbyCooks();
}

class MockCookRepository implements CookRepository {
  @override
  Future<List<CookModel>> getCooks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.cooks;
  }

  @override
  Future<List<CookModel>> searchCooks({String? query, String? cuisine}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.cooks.where((cook) {
      final matchesQuery = query == null ||
          query.isEmpty ||
          cook.name.toLowerCase().contains(query.toLowerCase()) ||
          cook.cuisines.any((c) => c.toLowerCase().contains(query.toLowerCase()));
      final matchesCuisine = cuisine == null ||
          cuisine == 'All' ||
          cook.cuisines.contains(cuisine);
      return matchesQuery && matchesCuisine;
    }).toList();
  }

  @override
  Future<CookModel?> getCookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.cooks.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CookModel>> getFeaturedCooks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.cooks.where((c) => c.isFeatured).toList();
  }

  @override
  Future<List<CookModel>> getNearbyCooks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final list = [...MockData.cooks];
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }
}
