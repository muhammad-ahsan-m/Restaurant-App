import 'package:flutter/material.dart';

import '../lists/lists.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bannerItems.length,
        itemBuilder: (context, index) {
          final item = bannerItems[index];
          final itemImage = bannerImage[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    item: item,
                    bannerImage: bannerImage
                  ),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      bannerImage[index],
                      fit: BoxFit.cover,
                      width: 200,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.error));
                      },
                    ),
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          item["name"]!,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// DetailPage to display item details
class DetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<String> bannerImage;

  const DetailPage({
    super.key,
    required this.item,
    required this.bannerImage,
  });

  @override
  Widget build(BuildContext context) {
    // Find the index of the item in the bannerItems list based on the name
    int index = bannerItems.indexWhere((element) => element["name"] == item["name"]);
    String imagePath = index != -1 ? bannerImage[index] : 'assets/images/default.jpg'; // Fallback image if not found

    return Scaffold(
      appBar: AppBar(
        title: Text(item["name"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image or banner section
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 200),
                ),
              ),
              const SizedBox(height: 20),

              // Item name and description section
              Text(
                item["name"],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item["description"],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Price Section
              Card(
                color: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item["price"],
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ingredients Section
              const Text(
                "Ingredients:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    item["ingredients"],
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),

              // "Order Now" Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Action when 'Order Now' is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Order Now", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}