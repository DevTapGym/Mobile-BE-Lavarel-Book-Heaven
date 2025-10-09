import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:heaven_book_app/interceptors/auth_interceptor.dart';

class AuthService {
  late final Dio _publicDio;
  late final Dio _privateDio;
  late final CookieJar _cookieJar;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //10.0.2.2
  //192.168.10.89
  AuthService() {
    _cookieJar = CookieJar();

    _publicDio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _privateDio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _publicDio.interceptors.add(CookieManager(_cookieJar));
    _privateDio.interceptors.add(CookieManager(_cookieJar));
    _privateDio.interceptors.add(AuthInterceptor(_secureStorage, this));
  }

  Dio get privateDio => _privateDio;
  Dio get publicDio => _publicDio;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _publicDio.post(
        '/auth/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        final isActive = data['is_active'] ?? false;

        return {
          'success': true,
          'status': response.data['status'],
          'message': response.data['message'] ?? 'Đăng ký thành công',
          'user': data,
          'isActive': isActive,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Đăng ký thất bại');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Đăng ký thất bại');
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _publicDio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];

        // Lưu access token
        await _secureStorage.write(
          key: 'access_token',
          value: data['access_token'],
        );

        // Lấy refresh token từ header (Set-Cookie)
        final setCookieHeader = response.headers['set-cookie'];

        if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
          final cookies =
              setCookieHeader
                  .map((str) => Cookie.fromSetCookieValue(str))
                  .where((c) => c.name == 'refresh_token')
                  .toList();

          if (cookies.isNotEmpty) {
            final uri = Uri.parse(_publicDio.options.baseUrl);
            await _cookieJar.saveFromResponse(uri, cookies);
            debugPrint('✅ Refresh token đã được lưu thành công');
          } else {
            throw Exception('Không tìm thấy refresh_token trong header');
          }
        }

        // Lưu trạng thái user
        final userData = data['user'] ?? data['account'] ?? {};
        final isActiveValue = userData['is_active'] ?? 0;

        // Lưu is_active từ user object
        await _secureStorage.write(
          key: 'is_active',
          value: isActiveValue.toString(),
        );

        // Check xem đã lưu thành công chưa
        final savedIsActive = await _secureStorage.read(key: 'is_active');
        debugPrint(
          '🔍 [Login Check] Is Active đã lưu: ${savedIsActive != null ? "✅ Có ($savedIsActive)" : "❌ Không"}',
        );

        final isActive = userData['is_active'] == 1;

        return {
          'token': data['access_token'],
          'user': userData,
          'isActive': isActive,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Đăng nhập thất bại');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Đăng nhập thất bại');
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<String?> getRefreshToken() async {
    final uri = Uri.parse(_publicDio.options.baseUrl);
    final cookies = await _cookieJar.loadForRequest(uri);
    final refresh = cookies.firstWhere(
      (cookie) => cookie.name == 'refresh_token',
      orElse: () => Cookie('refresh_token', ''),
    );
    return refresh.value.isNotEmpty ? refresh.value : null;
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final oldToken = await getRefreshToken();
      if (oldToken == null || oldToken.isEmpty) {
        throw Exception('Không tìm thấy refresh token trong cookie');
      }

      final response = await _publicDio.post(
        '/auth/refresh',
        options: Options(headers: {'Cookie': 'refresh_token=$oldToken'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];

        // 3️⃣ Lưu access token mới
        await _secureStorage.write(
          key: 'access_token',
          value: data['access_token'],
        );

        // 4️⃣ Xóa refresh token cũ trong cookie
        final uri = Uri.parse(_publicDio.options.baseUrl);
        await _cookieJar.delete(uri, true);

        // 5️⃣ Lấy refresh token mới từ response header (Set-Cookie)
        final setCookieHeader = response.headers['set-cookie'];
        if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
          final cookies =
              setCookieHeader
                  .map((str) => Cookie.fromSetCookieValue(str))
                  .where((c) => c.name == 'refresh_token')
                  .toList();

          if (cookies.isNotEmpty) {
            await _cookieJar.saveFromResponse(uri, cookies);
            debugPrint('✅ Refresh token mới đã được lưu thành công');
          } else {
            throw Exception('Server không trả về refresh token mới');
          }
        } else {
          throw Exception('Server không trả về cookie mới');
        }

        // 6️⃣ Lưu trạng thái user và trả về dữ liệu giống login
        final userData = data['user'] ?? {};
        final isActive = userData['is_active'] == 1;

        return {
          'token': data['access_token'],
          'user': userData,
          'isActive': isActive,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Làm mới token thất bại');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Làm mới token thất bại',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<Map<String, dynamic>> sendActivationCode() async {
    try {
      final response = await _privateDio.post('/auth/send-code');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Mã xác thực đã được gửi',
          'data': response.data['data'],
        };
      } else {
        throw Exception(
          response.data['message'] ?? 'Không thể gửi mã xác thực',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể gửi mã xác thực',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<Map<String, dynamic>> verifyActivationCode(String code) async {
    try {
      final response = await _privateDio.post(
        '/auth/verify-code',
        data: {'code': code},
      );

      if (response.statusCode == 200) {
        await _secureStorage.write(
          key: 'is_active',
          value: response.data['is_active'],
        );

        return {
          'success': true,
          'message': response.data['message'] ?? 'Kích hoạt thành công',
          'data': response.data['data'],
        };
      } else {
        throw Exception(response.data['message'] ?? 'Mã xác thực không hợp lệ');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Mã xác thực không hợp lệ',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<void> handleTokenExpired() async {
    await _secureStorage.deleteAll();
    debugPrint('❌ Phiên đăng nhập hết hạn, vui lòng đăng nhập lại.');
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _privateDio.post('/auth/logout');

      if (response.statusCode == 200) {
        await _secureStorage.deleteAll();
        final uri = Uri.parse(_publicDio.options.baseUrl);
        await _cookieJar.delete(uri, true);
        return {
          'success': true,
          'message': response.data['message'] ?? 'Đăng xuất thành công',
          'data': response.data['data'],
        };
      } else {
        await _cleanupLocalData();
        throw Exception(
          response.data['message'] ?? 'Đăng xuất không thành công',
        );
      }
    } on DioException catch (e) {
      await _cleanupLocalData();

      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Lỗi khi đăng xuất');
      }
      return {
        'success': true,
        'message': 'Đăng xuất thành công (offline)',
        'data': null,
      };
    } catch (e) {
      await _cleanupLocalData();
      return {'success': true, 'message': 'Đăng xuất thành công', 'data': null};
    }
  }

  Future<void> _cleanupLocalData() async {
    await _secureStorage.deleteAll();

    final uri = Uri.parse(_publicDio.options.baseUrl);
    await _cookieJar.delete(uri, true);

    debugPrint(
      '🧹 [AuthService] Hoàn tất cleanup: access token + refresh token + user data',
    );
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _publicDio.post(
        '/auth/forgot-password',
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message':
              response.data['message'] ?? 'Mã xác thực đã được gửi về email',
          'data': response.data['data'],
        };
      } else {
        throw Exception(
          response.data['message'] ?? 'Không thể gửi mã xác thực',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể gửi mã xác thực',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _publicDio.post(
        '/auth/reset-password',
        data: {"email": email, "code": code, "new_password": newPassword},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Đặt lại mật khẩu thành công',
          'data': response.data['data'],
        };
      } else {
        throw Exception(
          response.data['message'] ?? 'Không thể đặt lại mật khẩu',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể đặt lại mật khẩu',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  void dispose() {
    _publicDio.close();
    _privateDio.close();
  }
}
