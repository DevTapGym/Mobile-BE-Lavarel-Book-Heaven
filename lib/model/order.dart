import 'package:heaven_book_app/model/order_item.dart';
import 'package:heaven_book_app/model/status_order.dart';

class Order {
  final int id;
  final String orderNumber;
  final DateTime orderDate;
  final double shippingFee;
  final double totalAmount;
  final String note;
  final String receiverName;
  final String receiverAddress;
  final String receiverPhone;
  final String paymentMethod;
  final List<OrderItem> items;
  final List<StatusOrder> statusHistory;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.shippingFee,
    required this.totalAmount,
    required this.note,
    required this.receiverName,
    required this.receiverAddress,
    required this.receiverPhone,
    required this.paymentMethod,
    required this.items,
    required this.statusHistory,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      orderDate: DateTime.parse(json['created_at']),
      shippingFee: double.parse(json['shipping_fee'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      receiverName: json['receiver_name'] ?? '',
      receiverAddress: json['receiver_address'] ?? '',
      receiverPhone: json['receiver_phone'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      note: json['note'] ?? '',
      items:
          (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      statusHistory:
          (json['status_histories'] as List)
              .map((status) => StatusOrder.fromJson(status))
              .toList(),
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, orderNumber: $orderNumber, orderDate: $orderDate, shippingFee: $shippingFee, totalAmount: $totalAmount, note: $note, receiverName: $receiverName, receiverAddress: $receiverAddress, receiverPhone: $receiverPhone, paymentMethod: $paymentMethod, items: $items, statusHistory: $statusHistory}';
  }
}
