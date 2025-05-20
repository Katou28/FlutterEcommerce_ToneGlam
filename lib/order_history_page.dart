import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/models/cart_manager.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink[300]),
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          final orders = cartManager.orderHistory;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Reload order history
              await cartManager.loadOrderHistory();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${_formatDate(order.orderDate)}'),
                        Text('Status: ${order.status}'),
                        Text(
                            'Estimated Delivery: ${_formatDate(order.estimatedDelivery)}'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...order.items.map((item) => ListTile(
                                  leading: Image.asset(
                                    item.imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        Icon(Icons.image, color: Colors.grey),
                                  ),
                                  title: Text(item.name),
                                  subtitle: Text('Shade: ${item.shade}'),
                                  trailing: Text(
                                    '${item.price} x ${item.quantity}',
                                    style: TextStyle(
                                      color: Colors.pink[300],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'P ${order.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.pink[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Shipping Information:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${order.customerName}'),
                            Text('Phone: ${order.phone}'),
                            Text('Address: ${order.address1}'),
                            if (order.address2.isNotEmpty)
                              Text('         ${order.address2}'),
                            Text(
                                '${order.city}, ${order.zip}, ${order.country}'),
                            if (order.notes.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Notes: ${order.notes}'),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
