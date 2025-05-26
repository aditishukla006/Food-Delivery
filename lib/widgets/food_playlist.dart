import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodPlaylist extends StatelessWidget {
  const FoodPlaylist({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    final collection = FirebaseFirestore.instance.collection('food_playlist');
    final docs = ['food1', 'food2', 'food3'];

    List<Map<String, dynamic>> items = [];

    for (String docId in docs) {
      final doc = await collection.doc(docId).get();
      if (doc.exists) {
        items.add(doc.data()!);
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFoodItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No food items found.");
        }

        final foodItems = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Food playlist",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final item = foodItems[index];
                  final title = item['title'] ?? '';
                  final image = item['image'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          image.startsWith('http')
                              ? Image.network(
                                image,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                image,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
