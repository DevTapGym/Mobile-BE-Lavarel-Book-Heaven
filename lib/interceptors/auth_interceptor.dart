import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart'; // Import AuthService

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  final AuthService _authService; // Thêm AuthService

  // Prevent multiple concurrent refresh requests
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter; // Đổi từ String? thành bool

  AuthInterceptor(
    this._storage,
    this._dio,
    this._authService,
  ); // Update constructor

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if it's a 401 error with the specific message
    if (err.response?.statusCode == 401) {
      final responseData = err.response?.data;

      // Check if it's the specific unauthorized error
      if (responseData is Map<String, dynamic> &&
          responseData['error'] == 'Unauthorized' &&
          responseData['message'] == 'Token is invalid or not transmitted') {
        // Skip refresh for refresh token endpoint to avoid infinite loop
        if (err.requestOptions.path.contains('/refresh') ||
            err.requestOptions.path.contains('/auth/refresh')) {
          await _handleLogout();
          return handler.reject(err);
        }

        // Handle token refresh using AuthService
        final refreshSuccess = await _handleTokenRefresh();

        if (refreshSuccess) {
          // Get new token from storage
          final newToken = await _storage.read(key: 'access_token');

          if (newToken != null) {
            // Retry the original request with new token
            final retryOptions = err.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $newToken';

            try {
              final response = await _dio.fetch(retryOptions);
              return handler.resolve(response);
            } catch (retryError) {
              if (retryError is DioException) {
                return handler.reject(retryError);
              }
              return handler.reject(err);
            }
          }
        }

        // Refresh failed, logout user
        await _handleLogout();
        return handler.reject(err);
      }
    }

    // For other errors, continue with default behavior
    handler.next(err);
  }

  Future<bool> _handleTokenRefresh() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      return await _refreshCompleter?.future ?? false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      debugPrint('🔄 [AuthInterceptor] Bắt đầu refresh token...');

      final result = await _authService.refreshToken();

      final success = result['success'] == true;

      if (success) {
        debugPrint('✅ [AuthInterceptor] Refresh token thành công');
      } else {
        debugPrint(
          '❌ [AuthInterceptor] Refresh token thất bại: ${result['message']}',
        );
      }

      _refreshCompleter!.complete(success);
      return success;
    } catch (e) {
      debugPrint('🚨 [AuthInterceptor] Refresh token error: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<void> _handleLogout() async {
    try {
      debugPrint('🚪 [AuthInterceptor] Bắt đầu logout do token invalid...');

      await _authService.logout();
      await _authService.handleTokenExpired();

      debugPrint(
        '✅ [AuthInterceptor] Logout hoàn tất - đã trigger token expired event',
      );
    } catch (e) {
      debugPrint('🚨 [AuthInterceptor] Logout error: $e');

      try {
        await _storage.deleteAll();
        debugPrint('🧹 [AuthInterceptor] Fallback: Đã clear storage thủ công');
      } catch (storageError) {
        debugPrint('🚨 [AuthInterceptor] Storage clear error: $storageError');
      }
    }
  }
}
