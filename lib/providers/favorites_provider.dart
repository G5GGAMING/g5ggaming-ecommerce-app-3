import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  List<int> _favoriteIds = [];

  List<int> get favoriteIds => [..._favoriteIds];

  FavoritesProvider() {
    _initListener();
  }

  void _initListener() {
    // Listen to Auth changes to start listening to Favorites
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToUserFavorites(user.uid);
      } else {
        _favoriteIds = [];
        notifyListeners();
      }
    });
  }

  void _listenToUserFavorites(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _favoriteIds = snapshot.docs.map((doc) => int.tryParse(doc.id) ?? 0).toList();
      notifyListeners();
    });
  }

  bool isFavorite(Product product) => _favoriteIds.contains(product.id);

  Future<void> toggleFavorite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(product.id.toString());

    if (_favoriteIds.contains(product.id)) {
      await docRef.delete();
    } else {
      await docRef.set({'productId': product.id, 'addedAt': FieldValue.serverTimestamp()});
    }
    // No need for notifyListeners here, the snapshots() listener will handle it real-time!
  }

  void syncWithProducts(List<Product> products) {
    for (var p in products) {
      p.isFavorite = _favoriteIds.contains(p.id);
    }
  }
}
