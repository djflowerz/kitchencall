class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String? photoUrl;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final double walletBalance;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.photoUrl,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.walletBalance = 0,
  });

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? photoUrl,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    double? walletBalance,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
