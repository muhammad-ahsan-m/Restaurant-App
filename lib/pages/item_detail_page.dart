import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final Function(Map<String, dynamic> cartItem) onAddToCart;

  const ItemDetailPage({super.key, required this.itemData, required this.onAddToCart});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;
  List<String> reviews = [];
  String reviewInput = '';
  double rating = 0.0;
  final List<String> images = [];

  @override
  void initState() {
    super.initState();

    if (widget.itemData['images'] != null) {
      images.addAll(List<String>.from(widget.itemData['images']));
    }
  }

  void _addToCart() {
    final cartItem = {
      "name": widget.itemData["placeName"],
      "quantity": quantity,
      "minOrder": widget.itemData["minOrder"],
      "image": widget.itemData["placeImage"]
    };

    widget.onAddToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${widget.itemData["placeName"]} x$quantity added to cart!"),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _addReview() {
    if (reviewInput.isNotEmpty) {
      setState(() {
        reviews.add(reviewInput);
        reviewInput = '';
      });
    }
  }

  void _rateItem(double newRating) {
    setState(() {
      rating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemData["placeName"] ?? "No Name"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Share functionality not implemented yet."),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                widget.itemData["placeImage"] ?? 'assets/images/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.itemData["placeName"] ?? "Unnamed Item",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: widget.itemData["placeItems"].map<Widget>((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(item)
                      )
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Min Order",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      widget.itemData["minOrder"]?.toString() ?? "N/A",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Quantity:", style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text("$quantity"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Add to Cart", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            const Text("Rate this item:", style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List<Widget>.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => _rateItem(index + 1.0),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text("Reviews:", style: TextStyle(fontSize: 16)),
            for (var review in reviews)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(review),
                ),
              ),
            TextField(
              onChanged: (value) {
                setState(() {
                  reviewInput = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Write a review",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addReview,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
