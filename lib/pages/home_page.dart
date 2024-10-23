import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/banner_widget.dart';
import 'item_detail_page.dart';
import 'favorites_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  var isGridView = false;
  var favorites = <String>{};
  String searchQuery = '';
  String selectedSort = 'Name';
  String selectedFilter = 'All';
  List<Map<String, dynamic>> cart = [];
  List<dynamic> dataJSON = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _loadData(); // Load data on init
  }

  // Load data from JSON
  Future<void> _loadData() async {
    String dataString = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    dataJSON = jsonDecode(dataString);
    _applySortingAndFiltering(); // Apply sorting and filtering
  }

  void _applySortingAndFiltering() {
    setState(() {
      // Sort data
      dataJSON.sort((a, b) {
        if (selectedSort == 'Name') {
          return a["placeName"].compareTo(b["placeName"]);
        } else {
          return int.parse(a["minOrder"]).compareTo(int.parse(b["minOrder"]));
        }
      });
    });
  }

  Future<List<Widget>> createList() async {
    List<Widget> items = [];

    for (var object in dataJSON) {
      // Apply filter
      if (selectedFilter != 'All' && object["category"] != selectedFilter) continue;

      String finalString = object["placeItems"].join(" | ");

      // Apply search
      if (object["placeName"].toLowerCase().contains(searchQuery.toLowerCase())) {
        items.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              _createRoute(ItemDetailPage(itemData: object, onAddToCart: _addToCart)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, spreadRadius: 2.0, blurRadius: 5.0),
                ],
              ),
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    child: Image.asset(
                      object["placeImage"],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(object["placeName"]),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: Text(
                              finalString,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            "Min. Order: ${object["minOrder"]}",
                            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      favorites.contains(object["placeName"]) ? Icons.favorite : Icons.favorite_border,
                      color: favorites.contains(object["placeName"]) ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favorites.contains(object["placeName"])) {
                          favorites.remove(object["placeName"]);
                        } else {
                          favorites.add(object["placeName"]);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        cart.add({
                          "name": object["placeName"],
                          "minOrder": object["minOrder"],
                          "image": object["placeImage"],
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("${object["placeName"]} added to cart!"),
                        behavior: SnackBarBehavior.floating,
                      ));
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }

    return items;
  }

  void _addToCart(Map<String, dynamic> cartItem) {
    setState(() {
      cart.add(cartItem);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Foodies"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                _createRoute(FavoritesPage(favorites: favorites)),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCartDialog(context);
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: ScaleTransition(
                    scale: _animationController.drive(CurveTween(curve: Curves.elasticOut)),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      value: selectedSort,
                      items: const [
                        DropdownMenuItem(value: 'Name', child: Text("Sort by Name")),
                        DropdownMenuItem(value: 'Order', child: Text("Sort by Min Order")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value as String;
                          _applySortingAndFiltering(); // Reapply sorting after selection
                        });
                      },
                    ),
                    DropdownButton(
                      value: selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text("All Categories")),
                        DropdownMenuItem(value: 'Fast Food', child: Text("Fast Food")),
                        DropdownMenuItem(value: 'Chinese', child: Text("Chinese")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value as String;
                          _applySortingAndFiltering(); // Reapply sorting after selection
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const BannerWidget(),
              Expanded(
                child: FutureBuilder<List<Widget>>(
                  future: createList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error loading items"));
                    } else {
                      return ListView(children: snapshot.data!);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Your Cart"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                var cartItem = cart[index];
                return ListTile(
                  title: Text(cartItem["name"]),
                  subtitle: Text("Min. Order: ${cartItem["minOrder"]}"),
                  leading: Image.asset(cartItem["image"]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
