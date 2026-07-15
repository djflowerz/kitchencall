import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/booking_repository.dart';
import '../models/booking_model.dart';
import 'booking_flow_provider.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => MockBookingRepository());

final bookingsProvider = FutureProvider<List<BookingModel>>((ref) {
  return ref.watch(bookingRepositoryProvider).getBookings();
});

final bookingActionsProvider = Provider((ref) => BookingActions(ref));

class BookingActions {
  BookingActions(this.ref);
  final Ref ref;

  Future<BookingModel> confirmBooking() async {
    final draft = ref.read(bookingFlowProvider);
    final cook = draft.cook!;
    final booking = BookingModel(
      id: '',
      cookId: cook.id,
      cookName: cook.name,
      cookPhotoUrl: cook.photoUrl,
      serviceType: draft.serviceType ?? 'Daily Meal',
      mealSlot: draft.mealSlot,
      date: draft.date ?? DateTime.now(),
      timeSlot: draft.timeSlot ?? 'ASAP',
      numberOfPeople: draft.numberOfPeople,
      selectedMeals: draft.selectedMeals,
      ingredientOption: draft.ingredientOption,
      specialInstructions: draft.specialInstructions,
      travelFee: draft.travelFee,
      serviceFee: draft.serviceFee,
      ingredientsCost: draft.ingredientsCost,
      total: draft.total,
      location: 'Kilimani, Nairobi',
      wantsDelivery: draft.wantsDelivery,
    );
    final created = await ref.read(bookingRepositoryProvider).createBooking(booking);
    ref.invalidate(bookingsProvider);
    ref.read(bookingFlowProvider.notifier).reset();
    return created;
  }

  Future<void> cancel(String id) async {
    await ref.read(bookingRepositoryProvider).cancelBooking(id);
    ref.invalidate(bookingsProvider);
  }
}

/// Favorite cook IDs, kept client-side for now.
class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super({});

  void toggle(String cookId) {
    final set = {...state};
    if (set.contains(cookId)) {
      set.remove(cookId);
    } else {
      set.add(cookId);
    }
    state = set;
  }

  bool isFavorite(String cookId) => state.contains(cookId);
}

final favoritesProvider = StateNotifierProvider<FavoritesController, Set<String>>(
  (ref) => FavoritesController(),
);
