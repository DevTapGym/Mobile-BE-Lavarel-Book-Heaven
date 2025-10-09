import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final AuthService _authService;
  bool _isRefreshing = false;
  Completer<void>? _refreshTokenCompleter;

  AuthInterceptor(this._storage, this._authService);

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
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      if (_isRefreshing) {
        await _refreshTokenCompleter?.future;
        final newToken = await _storage.read(key: 'access_token');
        requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final cloneReq = await _authService.privateDio.fetch(requestOptions);
        return handler.resolve(cloneReq);
      }

      _isRefreshing = true;
      _refreshTokenCompleter = Completer();

      try {
        await _authService.refreshToken();
        _refreshTokenCompleter?.complete();

        final newToken = await _storage.read(key: 'access_token');
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final cloneReq = await _authService.privateDio.fetch(requestOptions);
        return handler.resolve(cloneReq);
      } catch (_) {
        await _authService.handleTokenExpired();
        return handler.reject(err);
      } finally {
        _isRefreshing = false;
        _refreshTokenCompleter = null;
      }
    }

    handler.next(err);
  }
}
