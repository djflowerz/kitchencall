import 'meal_model.dart';

enum BookingStatus { upcoming, active, completed, cancelled }

enum TrackingStage {
  accepted,
  buyingIngredients,
  travelling,
  arrived,
  cooking,
  completed,
}

extension TrackingStageX on TrackingStage {
  String get label {
    switch (this) {
      case TrackingStage.accepted:
        return 'Booking Accepted';
      case TrackingStage.buyingIngredients:
        return 'Buying Ingredients';
      case TrackingStage.travelling:
        return 'Travelling to You';
      case TrackingStage.arrived:
        return 'Arrived';
      case TrackingStage.cooking:
        return 'Cooking';
      case TrackingStage.completed:
        return 'Completed';
    }
  }
}

class BookingModel {
  final String id;
  final String cookId;
  final String cookName;
  final String cookPhotoUrl;
  final String serviceType; // Daily Meal, Special Occasion, Meal Prep, Custom
  final String mealSlot; // Breakfast / Lunch / Dinner
  final DateTime date;
  final String timeSlot;
  final int numberOfPeople;
  final List<MealModel> selectedMeals;
  final String ingredientOption;
  final String specialInstructions;
  final double travelFee;
  final double serviceFee;
  final double ingredientsCost;
  final double total;
  final BookingStatus status;
  final TrackingStage trackingStage;
  final String location;
  final bool wantsDelivery;

  const BookingModel({
    required this.id,
    required this.cookId,
    required this.cookName,
    required this.cookPhotoUrl,
    required this.serviceType,
    required this.mealSlot,
    required this.date,
    required this.timeSlot,
    required this.numberOfPeople,
    required this.selectedMeals,
    required this.ingredientOption,
    this.specialInstructions = '',
    this.travelFee = 0,
    this.serviceFee = 0,
    this.ingredientsCost = 0,
    required this.total,
    this.status = BookingStatus.upcoming,
    this.trackingStage = TrackingStage.accepted,
    this.location = '',
    this.wantsDelivery = false,
  });

  double get subtotal => selectedMeals.fold(0.0, (sum, m) => sum + m.price);

  BookingModel copyWith({
    BookingStatus? status,
    TrackingStage? trackingStage,
  }) {
    return BookingModel(
      id: id,
      cookId: cookId,
      cookName: cookName,
      cookPhotoUrl: cookPhotoUrl,
      serviceType: serviceType,
      mealSlot: mealSlot,
      date: date,
      timeSlot: timeSlot,
      numberOfPeople: numberOfPeople,
      selectedMeals: selectedMeals,
      ingredientOption: ingredientOption,
      specialInstructions: specialInstructions,
      travelFee: travelFee,
      serviceFee: serviceFee,
      ingredientsCost: ingredientsCost,
      total: total,
      status: status ?? this.status,
      trackingStage: trackingStage ?? this.trackingStage,
      location: location,
      wantsDelivery: wantsDelivery,
    );
  }
}
