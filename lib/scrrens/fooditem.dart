import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class FoodItem {
  final String image;
  final String title;
  final bool isVeg;
  final String rating;
  final String oldPrice;
  final String newPrice;

  FoodItem({
    required this.image,
    required this.title,
    required this.isVeg,
    required this.rating,
    required this.oldPrice,
    required this.newPrice,
  });

  factory FoodItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FoodItem(
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      isVeg: data['isVeg'] ?? false,
      rating: data['rating']?.toString() ?? '0',
      oldPrice: data['oldPrice']?.toString() ?? '0',
      newPrice: data['newPrice']?.toString() ?? '0',
    );
  }
}
