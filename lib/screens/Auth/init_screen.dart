import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(AuthService());
    _checkAutoLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final accessToken = await _secureStorage.read(key: 'access_token');
      final isActive = await _secureStorage.read(key: 'is_active');

      if (accessToken == null || accessToken.isEmpty) {
        print('❌ [InitScreen] Không tìm thấy access token → Chuyển sang Login');
        _navigateToLogin();
        return;
      }
      if (isActive == null) {
        print('⚠️ [InitScreen] Không tìm thấy is_active → Chuyển sang Login');
        _navigateToLogin();
        return;
      }
      if (_isTokenExpired(accessToken)) {
        print('⏰ [InitScreen] Token đã hết hạn → Thử refresh token');
        if (mounted) {
          await _handleRefreshToken();
        }
      }
      if (isActive == '0') {
        print('🎉 [InitScreen] Người dùng chưa xác thực → Login');
        if (mounted) {
          _navigateToLogin();
        }
      } else {
        print('🎉 [InitScreen] Token còn hạn → Chuyển thẳng vào Main');
        if (mounted) {
          _navigateToMain();
        }
      }
    } catch (e) {
      print(
        '🚨 [InitScreen] Lỗi khi kiểm tra auto login: $e → Chuyển sang Login',
      );
      _navigateToLogin();
    }
  }

  Future<void> _handleRefreshToken() async {
    try {
      print('⏳ [InitScreen] Bắt đầu refresh token...');

      // Trigger refresh token và đợi kết quả
      _authBloc.add(AppStarted());

      // Listen for result one time only
      await for (final state in _authBloc.stream) {
        if (state is AuthSuccess) {
          print('🎉 [InitScreen] Refresh token thành công → Chuyển vào Main');
          if (mounted) {
            _navigateToMain();
          }
          break;
        } else if (state is AuthFailure) {
          print('❌ [InitScreen] Refresh token thất bại: ${state.message}');
          if (mounted) {
            _navigateToLogin();
          }
          break;
        }
        // Ignore AuthLoading, continue listening
      }
    } catch (e) {
      print('🚨 [InitScreen] Lỗi refresh token: $e');
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

      print('📅 [InitScreen] Token hết hạn lúc: $expTime');
      print('📅 [InitScreen] Thời gian hiện tại: $now');
      print('📅 [InitScreen] Thời gian buffer (trừ 5 phút): $bufferedExpTime');

      final isExpired = bufferedExpTime.isBefore(now);

      return isExpired;
    } catch (e) {
      return true;
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: _authBloc,
                child: const LoginScreen(),
              ),
        ),
      );
    }
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang kiểm tra đăng nhập...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
