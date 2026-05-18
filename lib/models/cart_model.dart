import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double total;
  String status;

  OrderItem({
    required this.id,
    required this.products,
    required this.total,
    this.status = "Reviewing",
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products.map((e) => e.toJson()).toList(),
        'total': total,
        'status': status,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      products:
          (json['products'] as List).map((e) => CartItem.fromJson(e)).toList(),
      total: (json['total'] as num).toDouble(),
      status: json['status'],
    );
  }
}
