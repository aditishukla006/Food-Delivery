import 'package:flutter/material.dart';
import 'package:project/firebase_services.dart';
import 'package:project/scrrens/addtocart.dart';
import 'package:project/scrrens/fooditem.dart';
import 'package:project/widgets/cuisine_Section.dart';
import 'package:project/widgets/food_Scroll.dart';
import 'package:project/widgets/food_playlist.dart';
import 'package:project/widgets/hiverse_section.dart';
import 'package:project/widgets/leaderboard_section.dart';
import 'package:project/widgets/restaurant_Section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseService _firebaseService;
  bool isVeg = true;
  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ''),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 30, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              size: 30,
              color: Colors.black12,
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      //color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/img1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Leaderboard
              LeaderboardSection(),
              const SizedBox(height: 20),

              // Search
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.filter_alt_outlined),
                ],
              ),
              const SizedBox(height: 20),

              // Food Scroll
              FoodCarousel(),

              const SizedBox(height: 20),
              CuisineSection(),

              const SizedBox(height: 20),
              FoodPlaylist(),
              const SizedBox(height: 20),
              RestaurantSection(),
              //button
              const SizedBox(height: 30),
              Container(
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "View all hives",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              HiveverseSection(),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Eat ",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          TextSpan(
                            text: "&\nRepeat",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 12,
                            children: [
                              _buildFilterChip("under 200 🍏", () {}),
                              _buildFilterChip("top rated 🍴", () {}),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Switch(
                              value: isVeg,
                              onChanged: (val) {
                                setState(() {
                                  isVeg = val;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<FoodItem>>(
                    future: _firebaseService.getFoodItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No food items available"));
                      } else {
                        final foodItems = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: foodItems.length,
                          itemBuilder: (context, index) {
                            final foodItem = foodItems[index];
                            return _buildFoodItemCard(
                              context,
                              image: foodItem.image,
                              title: foodItem.title,
                              isVeg: foodItem.isVeg,
                              rating: foodItem.rating,
                              oldPrice: foodItem.oldPrice,
                              newPrice: foodItem.newPrice,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//custom widget
Widget _buildFilterChip(String label, Null Function() param1) {
  return Chip(
    label: Text(label),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.black12),
    ),
  );
}

Widget _buildFoodItemCard(
  BuildContext context, {
  required String image,
  required String title,
  required bool isVeg,
  required String rating,
  required String oldPrice,
  required String newPrice,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: isVeg ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isVeg ? "veg" : "non veg",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    oldPrice,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    newPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Addtocart()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Eat 🍴",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ],
    ),
  );
}
