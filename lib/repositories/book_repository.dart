import 'package:dio/dio.dart';
import 'package:heaven_book_app/model/book.dart';

class BookRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/v1/book'),
  );

  Future<List<Book>> getAllBooks() async {
    try {
      final response = await _dio.get('/?size=20&page=1');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> &&
            data['data'] is Map<String, dynamic> &&
            data['data']['result'] is List) {
          final List<dynamic> list = data['data']['result'];
          return list
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading books: $e');
    }
  }

  Future<Book> getBookById(int id) async {
    try {
      final response = await _dio.get('/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] != null) {
          return Book.fromJson(Map<String, dynamic>.from(data['data']));
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load book (status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error loading book: $e');
    }
  }

  Future<List<Book>> getPopularBooks() async {
    try {
      final response = await _dio.get('/popular');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load popular books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading popular books: $e');
    }
  }

  Future<List<Book>> getSaleOffBooks() async {
    try {
      final response = await _dio.get('/sale-off');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load popular books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading popular books: $e');
    }
  }

  Future<List<Book>> getBestSellingBooksInYear() async {
    try {
      final response = await _dio.get('/top-selling');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load popular books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading popular books: $e');
    }
  }

  Future<List<Book>> getBannerBooks() async {
    try {
      final response = await _dio.get('/banner');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load popular books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading popular books: $e');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _dio.get('/search/$query');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to search books (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  Future<List<Book>> getBooksByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/category/$categoryId');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> bookList = data['data'];
          return bookList
              .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception(
          'Failed to load books by category (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error loading books by category: $e');
    }
  }
}
