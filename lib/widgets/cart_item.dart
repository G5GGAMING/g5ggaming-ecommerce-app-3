import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/cart_provider.dart';
import '../models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final int productId;
  final CartItem item;

  const CartItemWidget({
    super.key,
    required this.productId,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final product = item.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: product.image.isNotEmpty ? product.image : 'https://via.placeholder.com/100',
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(width: 75, height: 75, color: Colors.grey.shade800),
                errorWidget: (ctx, url, err) => Container(
                  width: 75,
                  height: 75,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.image_not_supported, color: Colors.white, size: 35),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${(product.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.orangeAccent, size: 22),
                      onPressed: () => cart.removeSingleItem(productId),
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent, size: 22),
                      onPressed: () => cart.addItem(product),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => cart.removeItem(productId),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
