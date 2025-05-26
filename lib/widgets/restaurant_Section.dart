import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('restaurant').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No restaurants found."));
        }

        final restaurants = snapshot.data!.docs;

        return Column(
          children:
              restaurants.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final foodItems =
                    (data['fooditems'] as List<dynamic>? ?? []).map((item) {
                      final map = Map<String, dynamic>.from(item as Map);
                      return {
                        'image': map['image'] ?? '',
                        'price': map['price'].toString(),
                      };
                    }).toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _restaurantCard(
                    image: data['image'] ?? '',
                    name: data['name'] ?? '',
                    cuisine: data['cuisine'] ?? '',
                    trending: data['trending'] ?? false,
                    foodItems: foodItems,
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _restaurantCard({
    required String image,
    required String name,
    required String cuisine,
    required bool trending,
    required List<Map<String, dynamic>> foodItems,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Items + Restaurant Image Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Food Items
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      return _foodItem(item['image'], item['price']);
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Cuisine Row
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.red),
              const SizedBox(width: 4),
              const Icon(Icons.circle, size: 8, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cuisine,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Name + Trending
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trending)
                const Icon(Icons.trending_up, color: Colors.green, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _foodItem(String imagePath, String price) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            height: 55,
            width: 55,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹ $price',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
