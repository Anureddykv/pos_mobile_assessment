import 'package:pos_mobile_assessment/db/app_database.dart';
import 'package:pos_mobile_assessment/models/menu_item.dart';
import 'package:pos_mobile_assessment/models/order_row.dart';
import 'package:pos_mobile_assessment/models/payment.dart';

class OrderRepository {
  Future<List<Map<String, dynamic>>> getOrdersSummary() async {
    final db = await AppDatabase.getDatabase();
    final rows = await db.rawQuery('''
      SELECT orderId, MIN(orderDate) as orderDate, SUM(total) as orderTotal, COUNT(*) as itemsCount
      FROM orders
      GROUP BY orderId
      ORDER BY orderDate DESC, orderId DESC
    ''');
    return rows;
  }

  Future<List<OrderRow>> getOrderRows(int orderId) async {
    final db = await AppDatabase.getDatabase();
    final rows = await db.query('orders', where: 'orderId = ?', whereArgs: [orderId]);
    return rows.map((r) => OrderRow.fromMap(r)).toList();
  }

  Future<List<Payment>> getPaymentsForOrder(int orderId) async {
    final db = await AppDatabase.getDatabase();
    final rows = await db.query('payments', where: 'orderId = ?', whereArgs: [orderId]);
    return rows.map((r) => Payment.fromMap(r)).toList();
  }

  Future<MenuItem?> getMenuItem(int itemId) async {
    final db = await AppDatabase.getDatabase();
    final res = await db.query('menuItems', where: 'itemId = ?', whereArgs: [itemId]);
    if (res.isEmpty) return null;
    return MenuItem.fromMap(res.first);
  }

  Future<List<Map<String, dynamic>>> getAllMenuWithSize() async {
    final db = await AppDatabase.getDatabase();
    final rows = await db.rawQuery('''
      SELECT m.itemId, m.itemName, m.catId, m.menuId, ms.size, ms.price
      FROM menuItems m
      LEFT JOIN menu_sizes ms ON ms.itemId = m.itemId
      ORDER BY m.itemId, ms.id
    ''');
    return rows;
  }
}
