import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final products = context.watch<ProductProvider>().products;
    final favs = products.where((p) => favProvider.favoriteIds.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.transparent,
      ),
      body: favs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('No favorites added yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: favs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (ctx, i) => ProductCard(product: favs[i]),
            ),
    );
  }
}
