import 'package:dio/dio.dart';
import 'package:heaven_book_app/model/category.dart';

class CategoryService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/v1/category'),
  );

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/?page=1&pageSize=10');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> &&
            data['data'] != null &&
            data['data']['result'] is List) {
          final List<dynamic> list = data['data']['result'];
          return list
              .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load categories (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
