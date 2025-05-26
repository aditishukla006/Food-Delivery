import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/scrrens/home_scrren.dart';

class Addtocart extends StatefulWidget {
  const Addtocart({super.key});

  @override
  _AddtocartState createState() => _AddtocartState();
}

class _AddtocartState extends State<Addtocart> {
  bool hasAddressConfirmed = false;

  bool isHalf = true;
  Set<int> addedToCartIndices = {};
  List<Map<String, dynamic>> cartItems = [];
  int? selectedCartIndex; // currently selected cart item

  // current selected image in horizontal list
  List<Map<String, String>> savedAddresses = [
    {'name': 'Default User', 'address': '123 Main Street, City'},
  ];

  int selectedAddressIndex = 0;

  bool showAddressForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  double discountAmount = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
    //  _fetchCartItems();
  }

  void _fetchFoodItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('foodItem').get();
      setState(() {
        foodItems =
            snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'title': data['title']?.toString() ?? 'No title',
                'image': data['image']?.toString() ?? 'assets/thali1.jpg',
                'rating': data['rating'] is num ? data['rating'] : 0,
                'isVeg': data['isVeg'] is bool ? data['isVeg'] : true,
                'oldPrice': data['oldPrice'] is num ? data['oldPrice'] : 0,
                'newPrice':
                    data['newPrice'] is num
                        ? data['newPrice']
                        : (data['oldPrice'] is num ? data['oldPrice'] : 0),
              };
            }).toList();
      });
    } catch (e) {
      print("Error fetching food items: $e");
    }
  }

  // ignore: unused_element
  void _fetchCartItems() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
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
      // Toggle UI state for button background color
      if (addedToCartIndices.contains(index)) {
        addedToCartIndices.remove(index);
      } else {
        addedToCartIndices.add(index);
      }

      // Find if item already in cart
      int existingIndex = cartItems.indexWhere(
        (item) => item['image'] == foodItems[index]['image'],
      );

      double qtyChange = isHalf ? 0.5 : 1;

      if (existingIndex == -1) {
        cartItems.add({
          'image': foodItems[index]['image'],
          'name': foodItems[index]['title'],
          'price': foodItems[index]['newPrice'],
          'quantity': qtyChange,
        });
        selectedCartIndex = cartItems.length - 1; // new item
      } else {
        cartItems[existingIndex]['quantity'] += qtyChange;
        selectedCartIndex = existingIndex; // existing item
      }

      // Optional: Firestore update
      final user = _auth.currentUser;
      if (user != null) {
        _firestore.collection('users').doc(user.uid).collection('cart').add({
          'image': foodItems[index]['image'],
          'name': foodItems[index]['title'],
          'price': foodItems[index]['newPrice'],
          'quantity': qtyChange,
        });
      }
    });
  }

  void updateQuantity(bool isIncrement) {
    setState(() {
      if (selectedCartIndex == null) return;

      double qtyChange = isHalf ? 0.5 : 1;

      if (isIncrement) {
        cartItems[selectedCartIndex!]['quantity'] += qtyChange;
      } else {
        cartItems[selectedCartIndex!]['quantity'] -= qtyChange;
        if (cartItems[selectedCartIndex!]['quantity'] <= 0) {
          cartItems.removeAt(selectedCartIndex!);
          selectedCartIndex = null;
          return;
        }
      }

      // Optional: Firestore update
      final user = _auth.currentUser;
      if (user != null) {
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItems[selectedCartIndex!]['name'])
            .update({'quantity': cartItems[selectedCartIndex!]['quantity']});
      }
    });
  }

  void showAddressCard(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String address = '';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                25,
                16,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  Row(
                    children: [
                      const Text(
                        'Create new address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Show New Address Form Bottom Sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                        ),
                                        onChanged: (value) => name = value,
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter name'
                                                    : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Address',
                                        ),
                                        onChanged: (value) => address = value,
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter address'
                                                    : null,
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              savedAddresses.add({
                                                'name': name,
                                                'address': address,
                                              });
                                              selectedAddressIndex =
                                                  savedAddresses.length - 1;
                                            });
                                            Navigator.pop(context);
                                            setModalState(
                                              () {},
                                            ); // Refresh outer sheet
                                          }
                                        },
                                        child: const Text('Save Address'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Saved address list
                  if (savedAddresses.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: savedAddresses.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAddressIndex = index;
                            });
                            setModalState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  selectedAddressIndex == index
                                      ? Colors.amber.withOpacity(0.2)
                                      : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    selectedAddressIndex == index
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        savedAddresses[index]['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(savedAddresses[index]['address']!),
                                    ],
                                  ),
                                ),
                                Icon(
                                  selectedAddressIndex == 0
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Next Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // close bottom sheet

                      // Delay required to allow pop() to complete before setState
                      Future.delayed(Duration(milliseconds: 100), () {
                        setState(() {
                          hasAddressConfirmed = true;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  double getSubtotal() {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  double getDeliveryCharge() => 20;

  double getPlatformFee() => 0;

  double getTotal() {
    return getSubtotal() +
        getDeliveryCharge() +
        getPlatformFee() -
        discountAmount;
  }

  Widget _buildPriceRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹ ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isVeg = true;
    return Scaffold(
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
                          text: ' \n& Repeat',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilterChip(
                        label: Text('under 200'),
                        onSelected: (_) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded edges
                          side: const BorderSide(
                            color: Colors.black12,
                          ), // Light grey border
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        label: Text('top rated'),
                        onSelected: (_) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded edges
                          side: const BorderSide(
                            color: Colors.black12,
                          ), // Light grey border
                        ),
                      ),
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
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
                          final item = foodItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Image with rating overlay
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        item['image'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${item['rating']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 12),

                                // Details Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['isVeg'] ? '▲ non veg' : '● veg',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              item['isVeg']
                                                  ? Colors.red
                                                  : Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${item['oldPrice']}',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '₹${item['newPrice']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Eat Button
                                ElevatedButton(
                                  onPressed: () => addToCart(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        addedToCartIndices.contains(index)
                                            ? Colors.white
                                            : Colors.amber,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  child: const Text('Eat 🍴'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Half / Full Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ChoiceChip(
                          label: const Text('Half'),
                          selected: isHalf,
                          onSelected: (val) => setState(() => isHalf = true),
                          backgroundColor: Colors.white,
                          selectedColor: Colors.black,
                          labelStyle: TextStyle(
                            color: isHalf ? Colors.white : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // side: const BorderSide(color: Colors.amber),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text('Full'),
                          selected: !isHalf,
                          onSelected: (val) => setState(() => isHalf = false),
                          backgroundColor: Colors.white,
                          selectedColor: Colors.black,
                          labelStyle: TextStyle(
                            color: !isHalf ? Colors.white : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // side: const BorderSide(color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Horizontal Cart Images with item names (no quantity controls here)
                    if (cartItems.isNotEmpty)
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCartIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          selectedCartIndex == index
                                              ? Colors.amber
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      cartItems[index]['image'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Shared Quantity controls + Proceed button, one line only, for all items
                    if (selectedCartIndex != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => updateQuantity(true),
                                icon: const Icon(Icons.add),
                                color: Colors.green,
                              ),
                              Container(
                                width: 40,
                                height: 36,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.grey[100],
                                ),
                                child: Text(
                                  '${cartItems[selectedCartIndex!]['quantity']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => updateQuantity(false),
                                icon: const Icon(Icons.remove),
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),

                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => showAddressCard(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Proceed",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    if (hasAddressConfirmed) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cartItems.isEmpty)
                              const Text("Your cart is empty."),
                            if (cartItems.isNotEmpty)
                              ...cartItems.map((item) {
                                final imagePath = item['image'] ?? '';
                                final hasImage = imagePath.isNotEmpty;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            hasImage
                                                ? Image.asset(
                                                  imagePath,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      width: 50,
                                                      height: 50,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey[600],
                                                      ),
                                                    );
                                                  },
                                                )
                                                : Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'] ?? 'No Name',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Qty: ${item['quantity'] ?? 0}",
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "₹${((item['price'] ?? 0) * (item['quantity'] ?? 0)).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                            const Divider(thickness: 1),

                            TextField(
                              controller: couponController,
                              decoration: InputDecoration(
                                hintText: 'Enter coupon code',
                                suffixIcon: TextButton(
                                  child: const Text('Apply'),
                                  onPressed: () {
                                    String code = couponController.text.trim();
                                    setState(() {
                                      discountAmount =
                                          code == 'KUNALDEB2025' ? 150 : 0;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildPriceRow("Sub Total", getSubtotal()),
                            _buildPriceRow(
                              "Delivery Charges",
                              getDeliveryCharge(),
                            ),
                            _buildPriceRow("Discount", -discountAmount),
                            _buildPriceRow("Platform Fee", getPlatformFee()),

                            const Divider(thickness: 1),

                            _buildPriceRow("Total", getTotal(), isBold: true),

                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                if (cartItems.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Cart is empty. Add some items before checking out.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Order placed for ₹${getTotal().toStringAsFixed(2)}",
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Checkout"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
