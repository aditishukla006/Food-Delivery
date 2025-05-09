import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addtocart extends StatefulWidget {
  const Addtocart({super.key});

  @override
  _AddtocartState createState() => _AddtocartState();
}

class _AddtocartState extends State<Addtocart> {
  bool showSummaryCard = false;
  bool isHalf = true;
  bool showAddressForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, dynamic>> savedAddresses = [];

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> foodItems =
      []; // Food items list fetched from Firestore
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    // Fetch food items from Firestore
    _fetchFoodItems();
    // Fetch cart items from Firestore on initial load
    _fetchCartItems();
  }

  void _fetchFoodItems() async {
    try {
      final snapshot = await _firestore.collection('foodItem').get();
      setState(() {
        foodItems =
            snapshot.docs.map((doc) {
              // Safely access the 'newPrice' field
              var price =
                  doc.data().containsKey('newPrice')
                      ? doc['newPrice']
                      : doc['oldPrice'];
              return {
                'image': doc['image'],
                'title': doc['title'],
                'price': price, // Use the correct price field
                'rating': doc['rating'],
                'isVeg': doc['isVeg'],
              };
            }).toList();
      });
    } catch (e) {
      print("Error fetching food items: $e");
    }
  }

  // Fetch cart items from Firestore
  void _fetchCartItems() async {
    final user = _auth.currentUser; // Get the current user
    if (user != null) {
      final userId = user.uid; // Get the UID of the authenticated user
      try {
        final snapshot =
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('cart')
                .get();
        setState(() {
          cartItems =
              snapshot.docs.map((doc) {
                return {
                  'image': doc['image'],
                  'name': doc['name'],
                  'price': doc['price'],
                  'quantity': doc['quantity'],
                };
              }).toList();
        });
      } catch (e) {
        print("Error fetching cart items: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }

  void addToCart(int index) {
    setState(() {
      int existingIndex = cartItems.indexWhere(
        (item) => item['image'] == foodItems[index]['image'],
      );

      if (existingIndex == -1) {
        cartItems.add({
          'image': foodItems[index]['image'],
          'name': foodItems[index]['name'],
          'price': foodItems[index]['price'],
          'quantity': isHalf ? 0.5 : 1,
        });
      } else {
        cartItems[existingIndex]['quantity'] += isHalf ? 0.5 : 1;
      }

      // Add to Firestore (update cart)
      final user = _auth.currentUser;
      if (user != null) {
        _firestore.collection('users').doc(user.uid).collection('cart').add({
          'image': foodItems[index]['image'],
          'name': foodItems[index]['name'],
          'price': foodItems[index]['price'],
          'quantity': isHalf ? 0.5 : 1,
        });
      }
    });
  }

  void updateQuantity(int index, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        cartItems[index]['quantity'] += isHalf ? 0.5 : 1;
      } else {
        cartItems[index]['quantity'] -= isHalf ? 0.5 : 1;
        if (cartItems[index]['quantity'] <= 0) {
          cartItems.removeAt(index);
        }
      }

      // Update Firestore cart
      final user = _auth.currentUser;
      if (user != null) {
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItems[index]['name'])
            .update({'quantity': cartItems[index]['quantity']});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isVeg = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Eat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                        fontSize: 26,
                      ),
                      children: const [
                        TextSpan(
                          text: ' & Repeat',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilterChip(label: Text('under 200'), onSelected: (_) {}),
                      const SizedBox(width: 10),
                      FilterChip(label: Text('top rated'), onSelected: (_) {}),
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
                ],
              ),
            ),
            Expanded(
              child:
                  foodItems.isEmpty
                      ? Center(child: CircularProgressIndicator()) // Loading
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
                          final item = foodItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      item['image'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['type'] == 'veg'
                                              ? '● veg'
                                              : '▲ non veg',
                                          style: TextStyle(
                                            color:
                                                item['type'] == 'veg'
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '₹${item['price']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => addToCart(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text('Eat 🍴'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
            // Add cart summary and action buttons below
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                        label: Text('half'),
                        selected: isHalf,
                        onSelected: (val) => setState(() => isHalf = true),
                      ),
                      ChoiceChip(
                        label: Text('full'),
                        selected: !isHalf,
                        onSelected: (val) => setState(() => isHalf = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (cartItems.isNotEmpty)
                    Column(
                      children:
                          cartItems.map((item) {
                            int index = cartItems.indexOf(item);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      item['image'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('${item['name']} x${item['quantity']}'),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed:
                                            () => updateQuantity(index, false),
                                        icon: Icon(Icons.remove),
                                        color: Colors.red,
                                      ),
                                      Text('${item['quantity']}'),
                                      IconButton(
                                        onPressed:
                                            () => updateQuantity(index, true),
                                        icon: Icon(Icons.add),
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Text('₹${item['price'] * item['quantity']}'),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Proceed'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
