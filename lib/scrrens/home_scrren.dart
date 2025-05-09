import 'package:flutter/material.dart';
import 'package:project/firebase_services.dart';
import 'package:project/scrrens/addtocart.dart';
import 'package:project/scrrens/fooditem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> foodItems = [
    {"title": "Biriyani Lover", "image": "assets/biryani.png"},
    {"title": "Kwality Bites", "image": "assets/icecreame.jpg"},
    {"title": "Baarish-e-Pakoda", "image": "assets/pakoda.jpg"},
  ];
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
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 55), label: ''),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 55,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 55, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              size: 60,
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
              const Text(
                "Leaderboard",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset('assets/leaderboard1.png', height: 100),
                    SizedBox(width: 20),
                    Image.asset('assets/laderboard2.png', height: 100),
                    SizedBox(width: 20),
                    Image.asset('assets/leaderboard3.png', height: 100),
                    SizedBox(width: 20),
                    Image.asset('assets/leaderboard4.png', height: 100),
                    SizedBox(width: 20),
                    Image.asset('assets/leaderboard5.png', height: 100),
                  ],
                ),
              ),
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
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset('assets/biryani.png'),
                    SizedBox(width: 10),
                    Image.asset('assets/meggi.png'),
                    SizedBox(width: 10),
                    Image.asset('assets/burger.jpg'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/line1.png", width: 10),
                  const SizedBox(width: 8),
                  const Text(
                    "Cuisines you should try",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 8),
                  Image.asset("assets/line1.png", width: 10),
                ],
              ),
              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2.0,
                children: [
                  _CuisineCard(
                    image: 'assets/thali1.jpg',
                    title: 'Indian',
                    subtitle: 'Biriyani, Naan, Roti',
                  ),
                  _CuisineCard(
                    image: 'assets/chinese.jpg',
                    title: 'Chinese',
                    subtitle: 'Noodles, Fried Rice',
                  ),
                  _CuisineCard(
                    image: 'assets/pizza.jpg',
                    title: 'Italian',
                    subtitle: 'Pizza, Pasta',
                  ),
                  _CuisineCard(
                    image: 'assets/dhosa.jpg',
                    title: 'South Indian',
                    subtitle: 'Dosa, Idli, Vada',
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                "Food playlist",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final item = foodItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              item['image']!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.bottomCenter,
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
                                  item['title']!,
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
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Our ',
                      style: TextStyle(color: Colors.black, fontSize: 32),
                    ),
                    TextSpan(
                      text: '\n \t\t Featured ',
                      style: TextStyle(color: Colors.black, fontSize: 40),
                    ),
                    TextSpan(
                      text: 'Hives',
                      style: TextStyle(color: Colors.orange, fontSize: 40),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
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
                            height: 150,
                            width: 150,
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
                            "assets/clock.png",
                            width: 180,
                            height: 180,
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
                          "Indian/ chinese/ thai/ japanese",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            //fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Text(
                            "Clock Tower: Restaurant cum Cafe",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.trending_up, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
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
                            height: 150,
                            width: 150,
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
                            "assets/restaurant.jpg",
                            width: 180,
                            height: 180,
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
                          "Indian/ chinese/ thai/ japanese",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Text(
                            "Clock Tower: Restaurant cum Cafe",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.trending_up, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              //button
              const SizedBox(height: 30),
              Container(
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "View all hives",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hiveverse',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHiveImageCard(
                          imagePath: 'assets/drophive.png',
                          label: 'Parcel Delivery',
                        ),
                        _buildHiveImageCard(
                          imagePath: 'assets/medihive.png',
                          label: 'Medicines',
                        ),
                        _buildHiveImageCard(
                          imagePath: 'assets/shophive.png',
                          label: 'Groceries',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          _buildFoodImageCard('assets/cafe1.jpg'),
                          const SizedBox(width: 12),
                          _buildFoodImageCard('assets/cafe2.jpg'),
                          const SizedBox(width: 16),
                          _buildFoodImageCard('assets/cafe3.jpg'),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          TextSpan(
                            text: "&\nRepeat",
                            style: TextStyle(
                              fontSize: 35,
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
                    child: Wrap(
                      spacing: 12,
                      children: [
                        _buildFilterChip("under 200 🍏", () {
                          print("button click");
                        }),
                        _buildFilterChip("top rated 🍴", () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Spacer(),
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
Widget _buildFilterChip(String label, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black12),
      ),
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
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$rating 🍴",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
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
                  fontSize: 25,
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
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Addtocart()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Eat 🍴",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFoodImageCard(String imagePath) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    ),
  );
}

Widget _buildHiveImageCard({required String imagePath, required String label}) {
  return Column(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
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

Widget _CuisineCard({
  required String image,
  required String title,
  required String subtitle,
}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipOval(
        child: Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 15, color: Colors.black38),
      ),
    ),
  );
}

Widget _foodItem(String imagePath, String price) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(imagePath, height: 70, width: 70, fit: BoxFit.cover),
      ),
      const SizedBox(height: 6),
      Text(price, style: const TextStyle(fontSize: 20)),
    ],
  );
}
