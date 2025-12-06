class OrderRow {
  final int id;
  final String orderDate;
  final int orderId;
  final int itemId;
  final String? size;
  final double price;
  final int qty;
  final String orderStatus;
  final double total;

  OrderRow({
    required this.id,
    required this.orderDate,
    required this.orderId,
    required this.itemId,
    this.size,
    required this.price,
    required this.qty,
    required this.orderStatus,
    required this.total,
  });

  factory OrderRow.fromMap(Map<String, dynamic> m) => OrderRow(
    id: m['id'] as int,
    orderDate: m['orderDate'] as String,
    orderId: m['orderId'] as int,
    itemId: m['itemId'] as int,
    size: m['size'] as String?,
    price: (m['price'] as num).toDouble(),
    qty: m['qty'] as int,
    orderStatus: m['orderStatus'] as String,
    total: (m['total'] as num).toDouble(),
  );
}
