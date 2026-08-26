import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  CartProvider() {
    _loadCartData();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: 1),
      );
    }
    _saveCartData();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartData();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
      _saveCartData();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
      _saveCartData();
      notifyListeners();
    } else {
      removeItem(productId);
    }
  }

  void clear() {
    _items = {};
    _saveCartData();
    notifyListeners();
  }

  Future<void> _saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartJson = json.encode(
      _items.map((key, item) => MapEntry(key, item.toJson())),
    );
    await prefs.setString('cartData', cartJson);
  }

  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cartData')) {
      return;
    }
    
    final String? cartJson = prefs.getString('cartData');
    if (cartJson != null) {
      final Map<String, dynamic> decodedData = json.decode(cartJson) as Map<String, dynamic>;
      _items = decodedData.map(
        (key, item) => MapEntry(key, CartItem.fromJson(item)),
      );
      notifyListeners();
    }
  }
}
