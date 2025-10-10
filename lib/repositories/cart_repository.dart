import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heaven_book_app/model/cart.dart';
import 'package:heaven_book_app/services/api_client.dart';
import 'package:heaven_book_app/services/auth_service.dart';

class CartRepository {
  final apiClient = ApiClient(FlutterSecureStorage(), AuthService());

  Future<Cart> getMyCart() async {
    try {
      final response = await apiClient.privateDio.get('/cart/my-cart');

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map<String, dynamic> && body['data'] != null) {
          final cartData = Map<String, dynamic>.from(body['data']);
          return Cart.fromJson(cartData);
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load cart (status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error in getMyCart: $e');
      throw Exception('Error loading cart: $e');
    }
  }

  Future<void> updateCartItemQuantity(int cartItemId, int newQuantity) async {
    try {
      final response = await apiClient.privateDio.put(
        '/cart/update/$cartItemId',
        data: {'quantity': newQuantity},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update cart item (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('Error in updateCartItemQuantity: $e');
      throw Exception('Error updating cart item: $e');
    }
  }

  Future<void> addToCart(int bookId, int quantity) async {
    try {
      final response = await apiClient.privateDio.post(
        '/cart/add',
        data: {'bookId': bookId, 'quantity': quantity, 'cartId': null},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to add to cart (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('Error in addToCart: $e');
      throw Exception('Error adding to cart: $e');
    }
  }
}
