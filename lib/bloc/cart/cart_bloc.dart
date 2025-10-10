import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/repositories/book_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:heaven_book_app/repositories/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final BookRepository _bookRepository;

  CartBloc(this._cartRepository, this._bookRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await _cartRepository.getMyCart();
      final relatedBooks = await _bookRepository.getBooksByCategory(
        cart.items.isNotEmpty ? cart.items.first.bookId : 0,
      );
      emit(CartLoaded(cart: cart, relatedBooks: relatedBooks));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading());
      try {
        await _cartRepository.updateCartItemQuantity(
          event.cartItemId,
          event.newQuantity,
        );
        final updatedCart = await _cartRepository.getMyCart();
        emit(
          CartLoaded(
            cart: updatedCart,
            relatedBooks: currentState.relatedBooks,
          ),
        );
      } catch (e) {
        emit(CartError(e.toString()));
      }
    }
  }
}
