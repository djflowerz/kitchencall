class MealModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int prepTimeMinutes;
  final String category; // Breakfast, Lunch, Dinner, Dessert...

  const MealModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.prepTimeMinutes,
    required this.category,
  });
}
