import 'meal_model.dart';
import 'review_model.dart';

class CookModel {
  final String id;
  final String name;
  final String photoUrl;
  final List<String> cuisines;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final double startingPrice;
  final bool isVerified;
  final bool isFeatured;
  final bool isOnline;
  final int yearsExperience;
  final List<String> languages;
  final String bio;
  final List<String> galleryUrls;
  final List<MealModel> menu;
  final List<ReviewModel> reviews;
  final bool offersDelivery;

  const CookModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.cuisines,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.startingPrice,
    this.isVerified = true,
    this.isFeatured = false,
    this.isOnline = true,
    this.yearsExperience = 1,
    this.languages = const ['English'],
    this.bio = '',
    this.galleryUrls = const [],
    this.menu = const [],
    this.reviews = const [],
    this.offersDelivery = true,
  });
}
