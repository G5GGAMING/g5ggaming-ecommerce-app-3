import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

import 'cart_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'purchases_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  Widget _buildBody() {
    if (_selectedIndex == 1 && _selectedCategory != null)
      return _buildCategoryItemsContent();

    return [
      _buildHomeContent(),
      CategoriesScreen(
          onCategoryTap: (cat) => setState(() => _selectedCategory = cat)),
      const FavoritesScreen(),
      const CartScreen(),
    ][_selectedIndex];
  }

  Widget _buildCategoryItemsContent() {
    final products = context.watch<ProductProvider>().products;
    final cat = (_selectedCategory ?? '').trim().toLowerCase();
    final items =
        products.where((p) => p.category.toLowerCase() == cat).toList();

    return Column(
      children: [
        _buildHeader(cat.isEmpty ? 'Category' : '$cat Items', showBack: true),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text("No items found",
                      style: TextStyle(color: Colors.grey)))
              : _buildProductGrid(items),
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('ALL PRODUCTS'),
        Expanded(
          child: Consumer<ProductProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading && provider.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.products.isEmpty) {
                return const Center(
                    child: Text("No products found",
                        style: TextStyle(color: Colors.grey)));
              }

              return _buildProductGrid(provider.products);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, {bool showBack = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => setState(() => _selectedCategory = null),
            ),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (ctx, i) => ProductCard(product: products[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('E-Commerce App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, size: 28),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PurchasesScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 24),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          _selectedCategory = null;
        }),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded), label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${cart.itemCount}'),
              isLabelVisible: cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
