import 'package:flutter/cupertino.dart';
import 'package:heaven_book_app/model/order.dart';
import 'package:heaven_book_app/services/api_client.dart';

class OrderService {
  final ApiClient apiClient;
  OrderService(this.apiClient);

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
}
