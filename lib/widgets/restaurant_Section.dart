import 'package:flutter/material.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _restaurantCard(
          image: "assets/clock.png",
          name: "Clock Tower: Restaurant cum Cafe",
        ),
        const SizedBox(height: 30),
        _restaurantCard(
          image: "assets/restaurant.jpg",
          name: "Clock Tower: Restaurant cum Cafe",
        ),
      ],
    );
  }

  Widget _restaurantCard({required String image, required String name}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _foodItem("assets/biryani.png", "₹ 450.00"),
                      const SizedBox(width: 10),
                      _foodItem("assets/paneer.jpg", "₹ 450.00"),
                      const SizedBox(width: 10),
                      _foodItem("assets/curry.jpg", "₹ 450.00"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.circle, size: 10, color: Colors.red),
              Icon(Icons.circle, size: 10, color: Colors.green),
              SizedBox(width: 6),
              Text(
                "Indian / Chinese / Thai / Japanese",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.trending_up, color: Colors.green),
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
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(price, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
