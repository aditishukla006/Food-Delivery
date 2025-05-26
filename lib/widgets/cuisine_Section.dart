import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuisineSection extends StatelessWidget {
  const CuisineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/line1.png", width: 10),
            const SizedBox(width: 8),
            const Text(
              "Cuisines you should try",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 8),
            Image.asset("assets/line1.png", width: 10),
          ],
        ),
        const SizedBox(height: 20),
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('cuisine_card').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error loading cuisines"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No cuisines found."));
            }

            final docs = snapshot.data!.docs;

            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.6,
              children:
                  docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final image =
                        (data['image'] != null &&
                                data['image'].toString().isNotEmpty)
                            ? data['image']
                            : 'assets/default_food.png'; // fallback image

                    return _CuisineCard(
                      image: image,
                      title: data['title'] ?? 'No Title',
                      subtitle: data['subtitle'] ?? 'No Description',
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CuisineCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _CuisineCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipOval(
            child:
                image.startsWith('http')
                    ? Image.network(
                      image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
