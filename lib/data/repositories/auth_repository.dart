import '../../models/user_model.dart';
import '../mock_data.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String identifier, required String password});
  Future<UserModel> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });
  Future<void> sendPasswordReset(String identifier);
  Future<void> logout();
}

/// Swap for FirebaseAuth-backed implementation later. Method
/// signatures are deliberately backend-agnostic.
class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.currentUser;
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.currentUser.copyWith(fullName: fullName, phone: phone, email: email);
  }

  @override
  Future<void> sendPasswordReset(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
