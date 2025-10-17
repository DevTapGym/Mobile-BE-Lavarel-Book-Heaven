import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllOrders extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final String note;
  final String paymentMethod;
  final String phone;
  final String address;
  final String name;
  final List<Map<String, dynamic>> items;

  CreateOrder({
    required this.note,
    required this.paymentMethod,
    required this.phone,
    required this.address,
    required this.name,
    required this.items,
  });

  @override
  List<Object?> get props => [note, paymentMethod, phone, address, name, items];
}

class PlaceOrder extends OrderEvent {
  final String? note;
  final String paymentMethod;
  final int cartId;
  final String phone;
  final String address;
  final String name;

  PlaceOrder({
    this.note,
    required this.paymentMethod,
    required this.cartId,
    required this.phone,
    required this.address,
    required this.name,
  });

  @override
  List<Object?> get props => [
    note,
    paymentMethod,
    cartId,
    phone,
    address,
    name,
  ];
}

class LoadDetailOrder extends OrderEvent {
  final int orderId;

  LoadDetailOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
