import 'package:heaven_book_app/model/address.dart';
import 'package:heaven_book_app/model/order_item.dart';
import 'package:heaven_book_app/model/payment.dart';
import 'package:heaven_book_app/model/status_order.dart';

class Order {
  final int id;
  final String orderNumber;
  final DateTime orderDate;
  final double shippingFee;
  final double totalAmount;
  final String note;
  final Address shippingAddress;
  final Payment paymentMethod;
  final List<OrderItem> items;
  final List<StatusOrder> statusHistory;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.shippingFee,
    required this.totalAmount,
    required this.note,
    required this.shippingAddress,
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
      note: json['note'] ?? '',
      shippingAddress: Address.fromJson(json['shipping_address']),
      paymentMethod: Payment.fromJson(json['payment_method']),
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
}
