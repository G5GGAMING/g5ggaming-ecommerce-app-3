import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/cart_provider.dart';
import '../models/cart_model.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          title: const Text('Order Tracking'),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Reviewing"),
              Tab(text: "Received"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(cart.orders.where((o) => o.status == "Reviewing").toList()),
            _buildOrderList(cart.orders.where((o) => o.status == "Received").toList()),
            const Center(child: Text("No cancelled orders", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text("List is empty", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: orders.length,
      itemBuilder: (ctx, i) {
        final order = orders[i];
        return Card(
          color: const Color(0xFF1E1E2C),
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              ...order.products.map((item) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.product.image,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(width: 45, height: 45, color: Colors.black12),
                        errorWidget: (ctx, url, err) => const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                    title: Text(item.product.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: Text("Quantity: ${item.quantity}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    trailing: Text("\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                  )),
              const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status: ${order.status}",
                        style: TextStyle(
                            color: order.status == "Received" ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold)),
                    Text("Total: \$${order.total.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
