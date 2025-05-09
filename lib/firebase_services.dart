import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/scrrens/fooditem.dart';

class FirebaseService {
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch food items from Firestore
  Future<List<FoodItem>> getFoodItems() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('foodItem').get();
    return snapshot.docs.map((doc) => FoodItem.fromFirestore(doc)).toList();
  }
}
