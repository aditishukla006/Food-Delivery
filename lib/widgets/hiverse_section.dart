import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HiveverseSection extends StatelessWidget {
  const HiveverseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hiveverse',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Hive services from Firestore
          FutureBuilder<QuerySnapshot>(
            future:
                FirebaseFirestore.instance.collection('hive_services').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final docs = snapshot.data!.docs;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildHiveImageCard(
                        imagePath: data['image'], // like 'assets/drophive.png'
                        label: data['label'],
                      );
                    }).toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Cafe images from Firestore
          FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('cafe')
                    .doc('cafe1')
                    .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final data = snapshot.data!.data() as Map<String, dynamic>;

              final imagePaths = [data['img1'], data['img2'], data['img3']];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    ...imagePaths.map(
                      (path) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildFoodImageCard(path),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHiveImageCard({
    required String imagePath,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildFoodImageCard(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 200,
        height: 300,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
