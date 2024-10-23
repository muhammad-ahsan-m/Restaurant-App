import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final Set<String> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<String> sortedFavorites;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    sortedFavorites = widget.favorites.toList()..sort(); // Sort favorites alphabetically
  }

  void _removeFavorite(String favorite) {
    setState(() {
      sortedFavorites.remove(favorite);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$favorite removed from favorites.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _filterFavorites(String query) {
    setState(() {
      searchQuery = query;
      sortedFavorites = widget.favorites
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _filterFavorites,
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black38),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          sortedFavorites.isEmpty
              ? const Expanded(
            child: Center(
              child: Text(
                "No favorites added yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
              : Expanded( // Wrap ListView.builder with Expanded
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: sortedFavorites.length,
                itemBuilder: (context, index) {
                  String favoriteItem = sortedFavorites[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrange.withOpacity(0.5),
                        child: Text(
                          favoriteItem[0].toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        favoriteItem,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        "Tap to view details",
                        style: TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () {
                          _removeFavorite(favoriteItem);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
