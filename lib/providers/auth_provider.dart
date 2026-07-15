import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => MockAuthRepository());

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isLoggedIn => user != null;

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo) : super(const AuthState());
  final AuthRepository _repo;

  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.login(identifier: identifier, password: password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login failed. Please try again.');
      return false;
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.signUp(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Sign up failed. Please try again.');
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }

  void topUpWallet(double amount) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(user: user.copyWith(walletBalance: user.walletBalance + amount));
  }

  bool withdrawFromWallet(double amount) {
    final user = state.user;
    if (user == null || amount > user.walletBalance) return false;
    state = state.copyWith(user: user.copyWith(walletBalance: user.walletBalance - amount));
    return true;
  }

  void updateProfile({String? fullName, String? phone, String? email}) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(user: user.copyWith(fullName: fullName, phone: phone, email: email));
  }

  void updateDietaryPreferences({List<String>? preferences, List<String>? allergies}) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(
      user: user.copyWith(dietaryPreferences: preferences, allergies: allergies),
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
