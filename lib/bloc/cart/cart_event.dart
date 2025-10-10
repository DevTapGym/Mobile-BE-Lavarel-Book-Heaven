import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class UpdateCartItemQuantity extends CartEvent {
  final int cartItemId;
  final int newQuantity;

  UpdateCartItemQuantity(this.cartItemId, this.newQuantity);
}

class AddToCart extends CartEvent {
  final int bookId;
  final int quantity;

  AddToCart({required this.bookId, this.quantity = 1});

  @override
  List<Object?> get props => [bookId, quantity];
}
