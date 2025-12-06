import 'package:flutter/material.dart';
import 'package:pos_mobile_assessment/models/order_row.dart';
import 'package:pos_mobile_assessment/models/payment.dart';
import 'package:pos_mobile_assessment/repository/order_repository.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Future<List<OrderRow>> _rows;
  late Future<List<Payment>> _payments;

  @override
  void initState() {
    super.initState();
    final repo = Provider.of<OrderRepository>(context, listen: false);
    _rows = repo.getOrderRows(widget.orderId);
    _payments = repo.getPaymentsForOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<OrderRow>>(
              future: _rows,
              builder: (c, s) {
                if (!s.hasData)
                  return const Center(child: CircularProgressIndicator());
                final rows = s.data!;
                final orderTotal = rows.fold(0.0, (a, b) => a + b.total);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...rows.map(
                      (r) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade200,
                            child: Text(
                              '${r.qty}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            'Item ${r.itemId} ${r.size ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Unit: £${r.price.toStringAsFixed(2)}',
                          ),
                          trailing: Text(
                            '£${r.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Card(
                      color: Colors.teal.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: ListTile(
                        title: const Text(
                          'Order Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '£${orderTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Payments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Payment>>(
              future: _payments,
              builder: (c, s) {
                if (!s.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final pays = s.data!;
                if (pays.isEmpty) return const Text('No payments recorded');
                return Column(
                  children: pays
                      .map(
                        (p) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(
                              p.paymentType.toLowerCase().contains('cash')
                                  ? Icons.attach_money
                                  : Icons.credit_card,
                              color: Colors.green,
                            ),
                            title: Text(
                              '${p.paymentType} • £${p.totalPaid.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${p.paymentDate} • Status: ${p.paymentStatus}',
                            ),
                            trailing: Text(
                              'Due: £${p.amountDue.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: p.amountDue > 0
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
