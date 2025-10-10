import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final accessToken = await _secureStorage.read(key: 'access_token');
      final isActive = await _secureStorage.read(key: 'is_active');

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint(
          '❌ [InitScreen] Không tìm thấy access token → Chuyển sang Login',
        );
        _navigateToLogin();
        return;
      }
      if (isActive == null) {
        debugPrint(
          '⚠️ [InitScreen] Không tìm thấy is_active → Chuyển sang Login',
        );
        _navigateToLogin();
        return;
      }
      if (_isTokenExpired(accessToken)) {
        debugPrint('⏰ [InitScreen] Token đã hết hạn → Thử refresh token');
        if (mounted) {
          await _handleRefreshToken();
        }
      }
      if (isActive == '0') {
        debugPrint('🎉 [InitScreen] Người dùng chưa xác thực → Login');
        if (mounted) {
          _navigateToLogin();
        }
      }

      if (_isTokenExpired(accessToken) == false && isActive == '1') {
        debugPrint('🎉 [InitScreen] Token còn hạn → Chuyển thẳng vào Main');
        if (mounted) {
          _navigateToMain();
        }
      }
    } catch (e) {
      debugPrint(
        '🚨 [InitScreen] Lỗi khi kiểm tra auto login: $e → Chuyển sang Login',
      );
      _navigateToLogin();
    }
  }

  Future<void> _handleRefreshToken() async {
    try {
      debugPrint('⏳ [InitScreen] Bắt đầu refresh token...');

      // Sử dụng global AuthBloc thay vì local instance
      context.read<AuthBloc>().add(AppStarted());

      // Listen for result one time only
      await for (final state in context.read<AuthBloc>().stream) {
        if (state is AuthSuccess) {
          debugPrint(
            '🎉 [InitScreen] Refresh token thành công → Chuyển vào Main',
          );
          if (mounted) {
            _navigateToMain();
          }
          break;
        } else if (state is AuthFailure) {
          debugPrint('❌ [InitScreen] Refresh token thất bại: ${state.message}');
          if (mounted) {
            _navigateToLogin();
          }
          break;
        }
        // Ignore AuthLoading, continue listening
      }
    } catch (e) {
      debugPrint('🚨 [InitScreen] Lỗi refresh token: $e');
      if (mounted) {
        _navigateToLogin();
      }
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true;
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> payloadMap = json.decode(decoded);

      final exp = payloadMap['exp'];
      if (exp == null) {
        return true;
      }

      final expTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final bufferedExpTime = expTime.subtract(const Duration(minutes: 5));

      debugPrint('📅 [InitScreen] Token hết hạn lúc: $expTime');
      debugPrint('📅 [InitScreen] Thời gian hiện tại: $now');
      debugPrint(
        '📅 [InitScreen] Thời gian buffer (trừ 5 phút): $bufferedExpTime',
      );

      final isExpired = bufferedExpTime.isBefore(now);

      return isExpired;
    } catch (e) {
      return true;
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang kiểm tra đăng nhập...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
