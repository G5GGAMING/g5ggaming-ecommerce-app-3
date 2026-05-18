import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = FirebaseFirestore.instance;

      // Fetch from API first to ensure we have the latest and plenty of items
      final apiProducts = await ApiService.fetchProducts();
      _products = apiProducts;
      notifyListeners();

      // Sync to Firestore in background (silent success)
      for (var p in apiProducts) {
        db
            .collection('products')
            .doc(p.id.toString())
            .set(p.toMap())
            .catchError((e) {
          debugPrint("Sync error for ${p.id}: $e");
        });
      }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
      // Fallback: try Firestore if API fails
      try {
        final snapshot =
            await FirebaseFirestore.instance.collection('products').get();
        if (snapshot.docs.isNotEmpty) {
          _products = snapshot.docs.map((doc) => Product.fromDoc(doc)).toList();
        }
      } catch (fError) {
        debugPrint("Firestore Fallback Error: $fError");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Real-time updates - disabled to prevent overriding API results with incomplete Firestore data
  void listenToProducts() {
    // FirebaseFirestore.instance.collection('products').snapshots().listen((snapshot) {
    //   if (snapshot.docs.isNotEmpty) {
    //     _products = snapshot.docs.map((doc) => Product.fromDoc(doc)).toList();
    //     notifyListeners();
    //   }
    // });
  }
}
