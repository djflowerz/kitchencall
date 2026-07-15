class AddressModel {
  final String id;
  final String label; // Home, Work, Other
  final String fullAddress;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });
}
