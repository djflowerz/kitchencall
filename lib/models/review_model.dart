class ReviewModel {
  final String id;
  final String customerName;
  final String? customerPhotoUrl;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.customerName,
    this.customerPhotoUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
