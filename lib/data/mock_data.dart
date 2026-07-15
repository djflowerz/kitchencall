import '../models/cook_model.dart';
import '../models/meal_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';

/// Static mock data so every screen renders real-looking content
/// without a backend connected yet. Replace [MockData.cooks] etc. with
/// calls into your Firestore/Supabase repositories once the backend
/// is wired up — the rest of the app depends only on the repository
/// interfaces in `data/repositories`, not on this file directly.
class MockData {
  MockData._();

  static const currentUser = UserModel(
    id: 'u1',
    fullName: 'Sarah Wanjiku',
    phone: '+254 712 345 678',
    email: 'sarah.w@email.com',
    walletBalance: 2000,
    dietaryPreferences: ['Low Salt'],
    allergies: ['Peanuts'],
  );

  static const addresses = [
    AddressModel(
      id: 'a1',
      label: 'Home',
      fullAddress: 'Kilimani, Nairobi',
      latitude: -1.2921,
      longitude: 36.7833,
      isDefault: true,
    ),
    AddressModel(
      id: 'a2',
      label: 'Work',
      fullAddress: 'Westlands, Nairobi',
      latitude: -1.2648,
      longitude: 36.8055,
    ),
  ];

  static final List<CookModel> cooks = [
    CookModel(
      id: 'c1',
      name: 'Chef Amina',
      photoUrl: 'https://i.pravatar.cc/300?img=47',
      cuisines: const ['African', 'Swahili', 'Healthy'],
      rating: 4.9,
      reviewCount: 128,
      distanceKm: 1.5,
      startingPrice: 800,
      isFeatured: true,
      yearsExperience: 5,
      languages: const ['English', 'Kiswahili'],
      bio: 'Passionate chef with 5+ years of experience in African and '
          'Swahili cuisine. I love creating delicious, healthy meals with '
          'fresh ingredients.',
      galleryUrls: const [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
        'https://images.unsplash.com/photo-1516684732162-798a0062be99?w=400',
      ],
      menu: const [
        MealModel(id: 'm1', name: 'Jollof Rice', imageUrl: 'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=400', price: 600, prepTimeMinutes: 40, category: 'Lunch'),
        MealModel(id: 'm2', name: 'Grilled Chicken', imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400', price: 850, prepTimeMinutes: 45, category: 'Dinner'),
        MealModel(id: 'm3', name: 'Kachumbari Salad', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400', price: 250, prepTimeMinutes: 10, category: 'Sides'),
      ],
      reviews: [
        ReviewModel(id: 'r1', customerName: 'James Mwangi', rating: 5, comment: 'Amazing food and excellent service!', date: DateTime.now().subtract(const Duration(days: 2))),
        ReviewModel(id: 'r2', customerName: 'Grace Kamau', rating: 4.5, comment: 'Very professional and the food was delicious.', date: DateTime.now().subtract(const Duration(days: 5))),
      ],
    ),
    CookModel(
      id: 'c2',
      name: 'Chef David',
      photoUrl: 'https://i.pravatar.cc/300?img=12',
      cuisines: const ['Italian', 'Continental'],
      rating: 4.8,
      reviewCount: 98,
      distanceKm: 2.4,
      startingPrice: 700,
      yearsExperience: 4,
      languages: const ['English'],
      bio: 'Continental and Italian specialist. Restaurant-trained, '
          'now bringing that experience straight to your kitchen.',
      galleryUrls: const [
        'https://images.unsplash.com/photo-1481931098730-318b6f776db0?w=400',
        'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400',
      ],
      menu: const [
        MealModel(id: 'm4', name: 'Spaghetti Carbonara', imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400', price: 900, prepTimeMinutes: 30, category: 'Dinner'),
        MealModel(id: 'm5', name: 'Margherita Pizza', imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=400', price: 1100, prepTimeMinutes: 35, category: 'Dinner'),
      ],
      reviews: [
        ReviewModel(id: 'r3', customerName: 'Brian Otieno', rating: 5, comment: 'Good food, will book again.', date: DateTime.now().subtract(const Duration(days: 8))),
      ],
    ),
    CookModel(
      id: 'c3',
      name: 'Chef Mercy',
      photoUrl: 'https://i.pravatar.cc/300?img=45',
      cuisines: const ['Healthy', 'Vegan', 'Vegetarian'],
      rating: 4.7,
      reviewCount: 74,
      distanceKm: 3.1,
      startingPrice: 650,
      yearsExperience: 3,
      languages: const ['English', 'Kiswahili'],
      bio: 'Plant-based meals that don\'t compromise on flavor. '
          'Specializing in vegan and vegetarian home cooking.',
      galleryUrls: const [
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      ],
      menu: const [
        MealModel(id: 'm6', name: 'Vegetable Stir Fry', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400', price: 500, prepTimeMinutes: 25, category: 'Lunch'),
      ],
      reviews: [
        ReviewModel(id: 'r4', customerName: 'Lilian Akinyi', rating: 5, comment: 'Always on time and excellent meals.', date: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
    CookModel(
      id: 'c4',
      name: 'Chef James',
      photoUrl: 'https://i.pravatar.cc/300?img=33',
      cuisines: const ['BBQ', 'Grills', 'African'],
      rating: 4.7,
      reviewCount: 50,
      distanceKm: 4.0,
      startingPrice: 750,
      yearsExperience: 6,
      languages: const ['English'],
      bio: 'BBQ and grill specialist — perfect for weekend family '
          'gatherings and backyard events.',
      menu: const [
        MealModel(id: 'm7', name: 'BBQ Ribs', imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400', price: 1200, prepTimeMinutes: 60, category: 'BBQ'),
      ],
    ),
  ];

  static CookModel cookById(String id) =>
      cooks.firstWhere((c) => c.id == id, orElse: () => cooks.first);
}
