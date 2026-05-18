import 'package:flutter/material.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoriesScreen({
    super.key,
    required this.onCategoryTap,
  });

  static const List<Map<String, dynamic>> categories = [
    {'title': 'beauty', 'icon': Icons.spa, 'color': Colors.pinkAccent},
    {'title': 'fragrances', 'icon': Icons.sanitizer, 'color': Colors.purpleAccent},
    {'title': 'furniture', 'icon': Icons.chair, 'color': Colors.orangeAccent},
    {'title': 'groceries', 'icon': Icons.local_grocery_store, 'color': Colors.greenAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.transparent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
        ),
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          return CategoryItem(
            title: cat['title'],
            icon: cat['icon'],
            color: cat['color'],
            onTap: () => onCategoryTap(cat['title']),
          );
        },
      ),
    );
  }
}
