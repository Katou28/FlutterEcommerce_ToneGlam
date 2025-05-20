import 'cart_manager.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String customerName;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String zip;
  final String country;
  final String notes;
  final DateTime orderDate;
  final String status;
  final DateTime estimatedDelivery;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.customerName,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.zip,
    required this.country,
    required this.notes,
    required this.orderDate,
    this.status = 'Processing',
    required this.estimatedDelivery,
  });

  // Convert Order to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'price': item.price,
                'shade': item.shade,
                'quantity': item.quantity,
                'imageUrl': item.imageUrl,
              })
          .toList(),
      'total': total,
      'customerName': customerName,
      'phone': phone,
      'address1': address1,
      'address2': address2,
      'city': city,
      'zip': zip,
      'country': country,
      'notes': notes,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
    };
  }

  // Create Order from Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      items: (map['items'] as List)
          .map((item) => CartItem(
                id: item['id'],
                name: item['name'],
                price: item['price'],
                shade: item['shade'],
                quantity: item['quantity'],
                imageUrl: item['imageUrl'],
              ))
          .toList(),
      total: map['total'],
      customerName: map['customerName'],
      phone: map['phone'],
      address1: map['address1'],
      address2: map['address2'],
      city: map['city'],
      zip: map['zip'],
      country: map['country'],
      notes: map['notes'],
      orderDate: DateTime.parse(map['orderDate']),
      status: map['status'],
      estimatedDelivery: DateTime.parse(map['estimatedDelivery']),
    );
  }
}
