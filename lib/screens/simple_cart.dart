import 'package:flutter/material.dart';
import 'package:pos_mobile_assessment/models/cart_item_model.dart';

class SimpleCart extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  String _getKey(CartItem item) => '${item.id}-${item.size}';

  void addItem(CartItem item) {
    final k = item.key;
    if (_items.containsKey(k)) {
      _items[k]!.qty += 1;
    } else {
      _items[k] = item;
    }
    notifyListeners();
  }

  void increase(String key) {
    if (_items.containsKey(key)) {
      _items[key]!.qty += 1;
      notifyListeners();
    }
  }

  void decrease(String key) {
    if (_items.containsKey(key)) {
      if (_items[key]!.qty > 1) {
        _items[key]!.qty -= 1;
      } else {
        _items.remove(key);
      }
      notifyListeners();
    }
  }

  double get totalInclTax => _items.values.fold(
      0, (sum, item) => sum + item.unitPriceInclTax * item.qty);

  double get totalExclTax => _items.values.fold(
      0, (sum, item) => sum + (item.unitPriceInclTax / 1.125) * item.qty);

  double get taxAmount => totalInclTax - totalExclTax;

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
