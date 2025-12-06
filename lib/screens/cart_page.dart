import 'package:flutter/material.dart';
import 'package:pos_mobile_assessment/models/cart_item_model.dart';
import 'package:pos_mobile_assessment/models/menu_item.dart';
import 'package:provider/provider.dart';
import 'simple_cart.dart';

class CartPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(itemId: 1, itemName: 'Item1', catId: 1, menuId: 1),
    MenuItem(itemId: 2, itemName: 'Item2', catId: 1, menuId: 1),
    MenuItem(itemId: 3, itemName: 'Item3', catId: 2, menuId: 2),
    MenuItem(itemId: 4, itemName: 'Item4', catId: 2, menuId: 2),
    MenuItem(itemId: 5, itemName: 'Item5', catId: 2, menuId: 1),
    MenuItem(itemId: 6, itemName: 'Item6', catId: 3, menuId: 1),
    MenuItem(itemId: 7, itemName: 'Item7', catId: 3, menuId: 1),
    MenuItem(itemId: 8, itemName: 'Item8', catId: 4, menuId: 2),
    MenuItem(itemId: 9, itemName: 'Item9', catId: 4, menuId: 2),
    MenuItem(itemId: 10, itemName: 'Item10', catId: 5, menuId: 2),
  ];

  final Map<int, List<Map<String, dynamic>>> itemSizes = {
    1: [{'size': 'Small', 'price': 1.5}, {'size': 'Large', 'price': 2.5}],
    6: [{'size': 'Small', 'price': 2.5}, {'size': 'Large', 'price': 3.6}],
    8: [{'size': 'Small', 'price': 3.75}, {'size': 'Large', 'price': 6.5}],
  };

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu & Cart'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Menu items grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems[index];
                final sizes = itemSizes[menuItem.itemId];

                if (sizes != null) {
                  return Column(
                    children: sizes
                        .map((s) => Expanded(
                        child: itemButton(context, menuItem, s['size'], s['price'])))
                        .toList(),
                  );
                } else {
                  return itemButton(context, menuItem, null, null);
                }
              },
            ),
          ),

          // Sticky Cart Section
          Consumer<SimpleCart>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) return const SizedBox();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 8,
                        offset: const Offset(0, -2)),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cart items scrollable within limited height
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final it = cart.items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(it.fullTitle),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () =>
                                          cart.decrease('${it.id}-${it.size}'),
                                    ),
                                    Text('${it.qty}'),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () =>
                                          cart.increase('${it.id}-${it.size}'),
                                    ),
                                  ],
                                ),
                                Text(
                                    '£${(it.unitPriceInclTax * it.qty).toStringAsFixed(2)}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    rowTotal('Total (Incl Tax):', cart.totalInclTax),
                    rowTotal('Tax (12.5%):', cart.taxAmount),
                    rowTotal('Total (Excl Tax):', cart.totalExclTax),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Checkout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Checkout'),
                              content: Text(
                                  'Total payable: £${cart.totalInclTax.toStringAsFixed(2)}\nTax: £${cart.taxAmount.toStringAsFixed(2)}'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close')),
                                TextButton(
                                    onPressed: () {
                                      cart.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Confirm & Clear')),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget itemButton(BuildContext context, MenuItem item, String? size, double? price) {
    return GestureDetector(
      onTap: () {
        Provider.of<SimpleCart>(context, listen: false).addItem(
          CartItem(
            id: item.itemId,
            title: item.itemName,
            size: size ?? '',
            unitPriceInclTax: price ?? 3.0,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              size != null ? '${item.itemName} ($size)' : item.itemName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '£${(price ?? 3.0).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowTotal(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('£${value.toStringAsFixed(2)}')
        ],
      ),
    );
  }
}
