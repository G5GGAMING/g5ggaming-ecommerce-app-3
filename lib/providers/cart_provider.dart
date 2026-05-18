import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items = {};
  List<OrderItem> _orders = [];

  Map<int, CartItem> get items => {..._items};
  List<OrderItem> get orders => [..._orders];
  int get itemCount => _items.length;

  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  CartProvider() {
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([loadCart(), loadOrders()]);
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    saveCart();
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    saveCart();
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    saveCart();
    notifyListeners();
  }

  void checkout() {
    if (_items.isEmpty) return;

    final order = OrderItem(
      id: DateTime.now().toIso8601String(),
      products: _items.values.toList(),
      total: totalAmount,
    );

    _orders.add(order);
    _items = {};
    saveCart();
    saveOrders();
    notifyListeners();

    Timer(const Duration(seconds: 10), () {
      order.status = "Received";
      saveOrders();
      notifyListeners();
    });
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((k, v) => MapEntry(k.toString(), v.toJson()));
    await prefs.setString('cart', jsonEncode(data));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart');
    if (data == null) return;

    final decoded = jsonDecode(data) as Map<String, dynamic>;
    _items = decoded.map((k, v) => MapEntry(int.parse(k), CartItem.fromJson(v)));
    notifyListeners();
  }

  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _orders.map((e) => e.toJson()).toList();
    await prefs.setString('orders', jsonEncode(data));
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('orders');
    if (data == null) return;

    final decoded = jsonDecode(data) as List;
    _orders = decoded.map((e) => OrderItem.fromJson(e)).toList();
    notifyListeners();
  }
}
