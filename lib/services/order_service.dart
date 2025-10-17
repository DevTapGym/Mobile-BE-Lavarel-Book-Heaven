import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:heaven_book_app/model/order.dart';
import 'package:heaven_book_app/services/api_client.dart';

class OrderService {
  final ApiClient apiClient;
  OrderService(this.apiClient);

  Future<bool> createOrder({
    required String note,
    required String paymentMethod,
    required String phone,
    required String address,
    required String name,
    required List<Map<String, dynamic>> items, // thêm items
  }) async {
    try {
      final response = await apiClient.privateDio.post(
        '/order/place',
        data: {
          'note': note,
          'payment_method': paymentMethod,
          'phone': phone,
          'address': address,
          'name': name,
          'items': items, // truyền list items
        },
      );

      if (response.statusCode == 201) {
        debugPrint('✅ Order created successfully');
        return true;
      } else {
        throw Exception('Failed to create order: ${response.data['message']}');
      }
    } on DioException catch (dioError) {
      debugPrint('❌ DioException khi tạo đơn hàng: ${dioError.message}');

      if (dioError.response != null) {
        debugPrint('Status code: ${dioError.response?.statusCode}');
        debugPrint('Data: ${dioError.response?.data}');
        debugPrint('Headers: ${dioError.response?.headers}');
      }
      throw Exception('Lỗi khi tạo đơn hàng: ${dioError.message}');
    } catch (e) {
      debugPrint('Error creating order: $e');
      throw Exception('Error creating order: $e');
    }
  }

  Future<bool> placeOrder(
    String note,
    String paymentMethod,
    int cartId,
    String phone,
    String address,
    String name,
  ) async {
    try {
      final response = await apiClient.privateDio.post(
        '/order/place',
        data: {
          'note': note,
          'payment_method': paymentMethod,
          'cart_id': cartId,
          'phone': phone,
          'address': address,
          'name': name,
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create order ${response.data['message']}');
      }
    } on DioException catch (dioError) {
      debugPrint('❌ DioException khi tạo đơn hàng: ${dioError.message}');

      if (dioError.response != null) {
        debugPrint('Status code: ${dioError.response?.statusCode}');
        debugPrint('Data: ${dioError.response?.data}');
        debugPrint('Headers: ${dioError.response?.headers}');
      } else {
        debugPrint('Message: ${dioError.message}');
      }
      throw Exception('Lỗi ${dioError.message}');
    } catch (e) {
      debugPrint('Error creating order: $e');
      throw Exception('Error creating order: $e');
    }
  }

  Future<List<Order>> loadAllOrder() async {
    try {
      final response = await apiClient.privateDio.get('/order/user');
      final data = response.data['data'];
      final resultList = data['result'] as List;

      final orders =
          resultList.map((orderJson) => Order.fromJson(orderJson)).toList();

      return orders;
    } catch (e) {
      debugPrint('Error loading orders: $e');
      throw Exception('Error loading orders: $e');
    }
  }

  Future<Order> loadDetailOrder(int orderId) async {
    try {
      final response = await apiClient.privateDio.get('/order/$orderId');
      final data = response.data['data'];
      return Order.fromJson(data);
    } catch (e) {
      debugPrint('Error loading order details: $e');
      throw Exception('Error loading order details: $e');
    }
  }
}
