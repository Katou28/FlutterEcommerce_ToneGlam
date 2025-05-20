import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';
import 'package:toneglam/models/cart_manager.dart';
import 'package:toneglam/checkout_page.dart';
import 'package:toneglam/order_history_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.pink[300]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          final items = cartManager.items;
          final total = cartManager.total;

          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? _buildEmptyCart()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _buildCartItem(context, items[index]),
                      ),
              ),
              if (items.isNotEmpty) _buildCheckoutSection(context, total),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.error_outline, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.price,
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Shade: ${item.shade}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        context,
                        Icons.remove,
                        () => Provider.of<CartManager>(context, listen: false)
                            .updateQuantity(item.id, item.quantity - 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      _buildQuantityButton(
                        context,
                        Icons.add,
                        () {
                          if (item.quantity < 100) {
                            Provider.of<CartManager>(context, listen: false)
                                .updateQuantity(item.id, item.quantity + 1);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Maximum quantity limit reached'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => Provider.of<CartManager>(context, listen: false)
                  .removeItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.pink[300]!.withOpacity(0.1),
      child: IconButton(
        icon: Icon(icon, color: Colors.pink[300], size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'P ${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutPage()),
              );
            },
            child: const Text('Checkout Now', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
