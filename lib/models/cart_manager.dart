import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';

class CartItem {
  final String id;
  final String name;
  final String price;
  final String shade;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.shade,
    this.quantity = 1,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'shade': shade,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      shade: map['shade'],
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orderHistory = [];
  static const String _orderHistoryKey = 'order_history';

  CartManager() {
    loadOrderHistory();
  }

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orderHistory => List.unmodifiable(_orderHistory);
  double get total => _items.fold(
      0,
      (sum, item) =>
          sum +
          (double.parse(item.price.replaceAll('P ', '')) * item.quantity));

  Future<void> loadOrderHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderHistoryJson = prefs.getStringList(_orderHistoryKey);
      if (orderHistoryJson != null) {
        _orderHistory.clear();
        for (final orderJson in orderHistoryJson) {
          final orderMap = json.decode(orderJson);
          _orderHistory.add(Order.fromMap(orderMap));
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading order history: $e');
    }
  }

  Future<void> _saveOrderHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderHistoryJson =
          _orderHistory.map((order) => json.encode(order.toMap())).toList();
      await prefs.setStringList(_orderHistoryKey, orderHistoryJson);
    } catch (e) {
      print('Error saving order history: $e');
    }
  }

  void addItem(CartItem item) {
    final existingItemIndex =
        _items.indexWhere((element) => element.id == item.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity = quantity;
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    _orderHistory.add(order);
    await _saveOrderHistory();
    notifyListeners();
  }

  String generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  DateTime calculateEstimatedDelivery() {
    // Add 3-5 business days to current date for estimated delivery
    final now = DateTime.now();
    int daysToAdd = 3 + Random().nextInt(3); // Random between 3-5 days
    return now.add(Duration(days: daysToAdd));
  }
}
