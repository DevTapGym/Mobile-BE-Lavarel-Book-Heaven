// services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

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
        baseUrl: 'http://10.0.2.2:8000/api/v1/auth',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _privateDio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api/v1/auth',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _publicDio.interceptors.add(CookieManager(_cookieJar));
    _privateDio.interceptors.add(CookieManager(_cookieJar));

    _privateDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            throw DioException(
              requestOptions: options,
              error: 'No authentication token found',
              type: DioExceptionType.badResponse,
            );
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _handleTokenExpired();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _publicDio.post(
        '/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];

        await _secureStorage.write(key: 'user_data', value: data.toString());

        final isActive = data['is_active'] ?? false;
        await _secureStorage.write(
          key: 'is_active',
          value: isActive.toString(),
        );

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
        '/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];

        // 1️⃣ Lưu access token
        await _secureStorage.write(
          key: 'access_token',
          value: data['access_token'],
        );

        // 2️⃣ Lấy refresh token từ header (Set-Cookie)
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
            print('✅ Refresh token đã được lưu thành công');
          } else {
            throw Exception('Không tìm thấy refresh_token trong header');
          }
        }

        // 3️⃣ Lưu trạng thái user
        final userData = data['user'] ?? data['account'] ?? {};
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
      // 1️⃣ Lấy refresh token từ cookie
      final oldToken = await getRefreshToken();
      if (oldToken == null || oldToken.isEmpty) {
        throw Exception('Không tìm thấy refresh token trong cookie');
      }

      // 2️⃣ Gọi API refresh, truyền refresh token qua Cookie
      final response = await _publicDio.post(
        '/refresh',
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
            print('✅ Refresh token mới đã được lưu thành công');
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
      final response = await _privateDio.post('/activate/send-code');

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
        '/activate/verify-code',
        data: {'code': code},
      );

      if (response.statusCode == 200) {
        await _secureStorage.write(key: 'is_active', value: 'true');
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

  Future<void> _handleTokenExpired() async {
    await _secureStorage.deleteAll();
    // ignore: avoid_print
    print('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _privateDio.post('/logout');

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

    print(
      '🧹 [AuthService] Hoàn tất cleanup: access token + refresh token + user data',
    );
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _publicDio.post(
        '/forgot-password',
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
        '/reset-password',
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
