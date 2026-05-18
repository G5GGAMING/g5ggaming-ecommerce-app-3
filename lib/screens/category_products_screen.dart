import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Product> allProducts;

  const CategoryProductsScreen({
    super.key,
    required this.categoryTitle,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    final categoryItems = allProducts.where((p) {
      return p.category.trim().toLowerCase() ==
          categoryTitle.trim().toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: Text(
          categoryTitle.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: categoryItems.isEmpty
          ? const Center(
              child: Text(
                "No products found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: categoryItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (ctx, i) {
                return ProductCard(product: categoryItems[i]);
              },
            ),
    );
  }
}
