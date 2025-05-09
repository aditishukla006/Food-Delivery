import 'package:flutter/material.dart';

class Addtocart extends StatefulWidget {
  const Addtocart({super.key});

  @override
  _AddtocartState createState() => _AddtocartState();
}

class _AddtocartState extends State<Addtocart> {
  bool showSummaryCard = false;

  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Chicken Biriyani',
      'type': 'non veg',
      'rating': 5.0,
      'price': 300,
      'image': 'assets/biryani.png',
    },
    {
      'name': 'Aloo Paratha',
      'type': 'veg',
      'rating': 3.5,
      'price': 300,
      'image': 'assets/burger.jpg',
    },
    {
      'name': 'Pakoda',
      'type': 'veg',
      'rating': 4.5,
      'price': 300,
      'image': 'assets/pakoda.jpg',
    },
  ];

  List<Map<String, dynamic>> cartItems = [];
  bool isHalf = true;
  bool showAddressForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, String>> savedAddresses = [];

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
    });
  }

  void saveAddress() {
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
      setState(() {
        savedAddresses.add({
          'name': nameController.text,
          'address': addressController.text,
        });
        showAddressForm = false; // Hide the form after saving
      });
    }
  }

  void showAddressCard(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String address = '';

    print("Button Pressed: Opening address form");

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Create new address',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        print("New button clicked");

                        // Show the modal bottom sheet when the 'New' button is clicked
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          builder:
                              (_) => Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                        ),
                                        onChanged: (value) => name = value,
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter name'
                                                    : null,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Address',
                                        ),
                                        onChanged: (value) => address = value,
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter address'
                                                    : null,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            // If the form is valid, add the address
                                            setState(() {
                                              savedAddresses.add({
                                                'name': name,
                                                'address': address,
                                              });
                                              Navigator.pop(
                                                context,
                                              ); // Close the bottom sheet
                                            });
                                          }
                                        },
                                        child: Text('Save Address'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      },
                      icon: Icon(Icons.add, size: 16),
                      label: Text('New'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (savedAddresses.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: savedAddresses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    savedAddresses[index]['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(savedAddresses[index]['address']!),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showSummaryCard = true;
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
          ),
    );
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
              child: ListView.builder(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  item['type'] == 'veg' ? '● veg' : '▲ non veg',
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
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                    onPressed: () => showAddressCard(context),
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
