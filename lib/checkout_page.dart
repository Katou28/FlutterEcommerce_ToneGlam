import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/models/cart_manager.dart';
import 'package:toneglam/models/order.dart';
import 'package:toneglam/services/notification_service.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String zip = '';
  String country = '';
  String notes = '';
  String _paymentMethod = 'Cash on Delivery';
  String _onlinePaymentMethod = 'Visa';
  String _accountNumber = '';

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);
    final items = cartManager.items;
    final total = cartManager.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink[300]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shipping Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField('Full Name', (val) => name = val,
                  validator: (val) => val!.isEmpty ? 'Required' : null),
              _buildTextField('Phone Number', (val) => phone = val,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty ? 'Required' : null),
              _buildTextField('Address Line 1', (val) => address1 = val,
                  validator: (val) => val!.isEmpty ? 'Required' : null),
              _buildTextField(
                  'Address Line 2 (optional)', (val) => address2 = val),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField('City', (val) => city = val,
                          validator: (val) =>
                              val!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildTextField('ZIP Code', (val) => zip = val,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? 'Required' : null)),
                ],
              ),
              _buildTextField('Country', (val) => country = val,
                  validator: (val) => val!.isEmpty ? 'Required' : null),
              _buildTextField(
                  'Notes/Instructions (optional)', (val) => notes = val,
                  maxLines: 2),
              const SizedBox(height: 24),
              const Text('Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Cash on Delivery'),
                value: 'Cash on Delivery',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Online Payment'),
                value: 'Online Payment',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              if (_paymentMethod == 'Online Payment') ...[
                const SizedBox(height: 12),
                const Text('Select Online Payment Method',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text('Card'),
                  value: 'Visa',
                  groupValue: _onlinePaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _onlinePaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('GCash'),
                  value: 'GCash',
                  groupValue: _onlinePaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _onlinePaymentMethod = value!;
                    });
                  },
                ),
                _buildTextField('Account Number', (val) => _accountNumber = val,
                    validator: (val) => val!.isEmpty ? 'Required' : null),
              ],
              const SizedBox(height: 24),
              const Text('Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...items.map((item) => ListTile(
                    leading: Image.asset(item.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Icon(Icons.image, color: Colors.grey)),
                    title: Text(item.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle:
                        Text('Shade: ${item.shade}\nQty: ${item.quantity}'),
                    trailing: Text(item.price,
                        style: TextStyle(
                            color: Colors.pink[300],
                            fontWeight: FontWeight.bold)),
                    isThreeLine: true,
                  )),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('P ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300])),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () => _placeOrder(context, cartManager),
                  child:
                      const Text('Place Order', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  void _placeOrder(BuildContext context, CartManager cartManager) {
    if (!_formKey.currentState!.validate()) return;

    // Create new order
    final order = Order(
      id: cartManager.generateOrderId(),
      items: List.from(cartManager.items),
      total: cartManager.total,
      customerName: name,
      phone: phone,
      address1: address1,
      address2: address2,
      city: city,
      zip: zip,
      country: country,
      notes: notes,
      orderDate: DateTime.now(),
      estimatedDelivery: cartManager.calculateEstimatedDelivery(),
    );

    // Add order to history
    cartManager.addOrder(order);

    // Create notification for the order using Consumer
    final notificationService =
        Provider.of<NotificationService>(context, listen: false);
    notificationService.addOrderNotification(
      order.id,
      'Your order #${order.id} has been placed successfully! Estimated delivery: ${_formatDate(order.estimatedDelivery)}',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Thank you for your purchase. Your order is being processed.'),
            const SizedBox(height: 16),
            Text('Order ID: ${order.id}'),
            Text('Estimated Delivery: ${_formatDate(order.estimatedDelivery)}'),
            Text('Payment Method: $_paymentMethod'),
            if (_paymentMethod == 'Online Payment') ...[
              Text('Payment Details: $_onlinePaymentMethod'),
              Text('Account Number: $_accountNumber'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartManager.clear();
              Navigator.of(context)
                ..pop()
                ..pop(); // Go back to previous page
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
