import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cook_model.dart';
import '../models/meal_model.dart';

/// Mutable draft that accumulates choices as the customer moves through
/// Select Service -> Date/Time -> Menu -> Ingredients -> Summary -> Payment.
/// Cleared once the booking is confirmed (see [BookingFlowController.reset]).
class BookingDraft {
  final CookModel? cook;
  final String? serviceType;
  final String mealSlot;
  final DateTime? date;
  final String? timeSlot;
  final int numberOfPeople;
  final List<MealModel> selectedMeals;
  final String ingredientOption;
  final String specialInstructions;
  final bool wantsDelivery;

  const BookingDraft({
    this.cook,
    this.serviceType,
    this.mealSlot = 'Lunch',
    this.date,
    this.timeSlot,
    this.numberOfPeople = 1,
    this.selectedMeals = const [],
    this.ingredientOption = 'I already have ingredients',
    this.specialInstructions = '',
    this.wantsDelivery = false,
  });

  double get mealsSubtotal => selectedMeals.fold(0.0, (sum, m) => sum + m.price);
  double get travelFee => 150;
  double get serviceFee => 100;
  double get ingredientsCost => ingredientOption.startsWith('KitchenCall') ? 400 : 0;
  double get total => mealsSubtotal + travelFee + serviceFee + ingredientsCost;

  BookingDraft copyWith({
    CookModel? cook,
    String? serviceType,
    String? mealSlot,
    DateTime? date,
    String? timeSlot,
    int? numberOfPeople,
    List<MealModel>? selectedMeals,
    String? ingredientOption,
    String? specialInstructions,
    bool? wantsDelivery,
  }) {
    return BookingDraft(
      cook: cook ?? this.cook,
      serviceType: serviceType ?? this.serviceType,
      mealSlot: mealSlot ?? this.mealSlot,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      ingredientOption: ingredientOption ?? this.ingredientOption,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      wantsDelivery: wantsDelivery ?? this.wantsDelivery,
    );
  }
}

class BookingFlowController extends StateNotifier<BookingDraft> {
  BookingFlowController() : super(const BookingDraft());

  void startWithCook(CookModel cook) => state = BookingDraft(cook: cook);
  void setServiceType(String type) => state = state.copyWith(serviceType: type);
  void setMealSlot(String slot) => state = state.copyWith(mealSlot: slot);
  void setDateTime(DateTime date, String slot) =>
      state = state.copyWith(date: date, timeSlot: slot);
  void setPeopleCount(int count) => state = state.copyWith(numberOfPeople: count);

  void toggleMeal(MealModel meal) {
    final list = [...state.selectedMeals];
    if (list.any((m) => m.id == meal.id)) {
      list.removeWhere((m) => m.id == meal.id);
    } else {
      list.add(meal);
    }
    state = state.copyWith(selectedMeals: list);
  }

  void setIngredientOption(String option) => state = state.copyWith(ingredientOption: option);
  void setInstructions(String text) => state = state.copyWith(specialInstructions: text);
  void setWantsDelivery(bool value) => state = state.copyWith(wantsDelivery: value);

  void reset() => state = const BookingDraft();
}

final bookingFlowProvider =
    StateNotifierProvider<BookingFlowController, BookingDraft>((ref) => BookingFlowController());
