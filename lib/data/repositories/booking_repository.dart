import 'package:uuid/uuid.dart';
import '../../models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> createBooking(BookingModel draft);
  Future<void> cancelBooking(String id);
}

/// In-memory booking store standing in for Firestore's `bookings`
/// collection. Swap for a real implementation that writes to
/// Firestore/Supabase and keep the same method signatures.
class MockBookingRepository implements BookingRepository {
  static final List<BookingModel> _bookings = [];
  final _uuid = const Uuid();

  @override
  Future<List<BookingModel>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_bookings);
  }

  @override
  Future<BookingModel> createBooking(BookingModel draft) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = BookingModel(
      id: 'KC${_uuid.v4().substring(0, 6).toUpperCase()}',
      cookId: draft.cookId,
      cookName: draft.cookName,
      cookPhotoUrl: draft.cookPhotoUrl,
      serviceType: draft.serviceType,
      mealSlot: draft.mealSlot,
      date: draft.date,
      timeSlot: draft.timeSlot,
      numberOfPeople: draft.numberOfPeople,
      selectedMeals: draft.selectedMeals,
      ingredientOption: draft.ingredientOption,
      specialInstructions: draft.specialInstructions,
      travelFee: draft.travelFee,
      serviceFee: draft.serviceFee,
      ingredientsCost: draft.ingredientsCost,
      total: draft.total,
      location: draft.location,
      wantsDelivery: draft.wantsDelivery,
      status: BookingStatus.upcoming,
      trackingStage: TrackingStage.accepted,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<void> cancelBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
    }
  }
}
