import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heaven_book_app/model/user.dart';
import 'package:heaven_book_app/services/api_client.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final ApiClient apiClient;

  final StreamController<void> _onTokenExpiredController =
      StreamController.broadcast();
  Stream<void> get onTokenExpired => _onTokenExpiredController.stream;

  AuthService() {
    apiClient = ApiClient(_secureStorage, this);
  }

  Future<User> uploadAvatar(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await apiClient.privateDio.post(
        '/upload/avatar',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        debugPrint('Upload avatar thành công');
        final userJson = response.data['data'];
        return User.fromJson(userJson);
      } else {
        final message = response.data['message'] ?? 'Upload avatar thất bại';
        final error = response.data['error'];
        throw Exception(error != null ? '$message: $error' : message);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể upload avatar',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    } catch (e, stack) {
      debugPrint('Upload avatar error: $e');
      debugPrint('Stacktrace: $stack');
      rethrow;
    }
  }

  Future<bool> updateInfoUser(
    String name,
    String dateOfBirth,
    String phone,
    String gender,
  ) async {
    try {
      final response = await apiClient.privateDio.put(
        '/auth/edit-profile',
        data: {
          "name": name,
          "date_of_birth": dateOfBirth,
          "phone": phone,
          "gender": gender,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        debugPrint('Cập nhật thông tin người dùng thành công');
        return true;
      }

      final message = response.data['message'] ?? 'Cập nhật thất bại';
      final error = response.data['error'];
      debugPrint('Update user info failed: $message');
      throw Exception(error != null ? '$message: $error' : message);
    } catch (e, stack) {
      debugPrint('Update user info error: $e');
      debugPrint('Stacktrace: $stack');
      rethrow; // hoặc throw Exception('Chi tiết lỗi: $e');
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final response = await apiClient.privateDio.put(
        '/auth/change-password',
        data: {
          "current_password": currentPassword,
          "new_password": newPassword,
          "new_password_confirmation": newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Đổi mật khẩu thành công');
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Không thể đổi mật khẩu');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể đổi mật khẩu',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await apiClient.privateDio.get('/auth/me');

      if (response.statusCode == 200 && response.data['data'] != null) {
        final userJson = response.data['data']['account'];
        return User.fromJson(userJson);
      } else {
        throw Exception('Không thể lấy thông tin người dùng');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Không thể lấy thông tin người dùng',
        );
      }
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }
  }

  // ==================== LOGIN ====================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await apiClient.publicDio.post(
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

        // Lưu refresh token từ header (Set-Cookie)
        final setCookieHeader = response.headers['set-cookie'];
        if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
          final refreshCookie = setCookieHeader
              .map((str) => Cookie.fromSetCookieValue(str))
              .firstWhere(
                (c) => c.name == 'refresh_token',
                orElse: () => Cookie('refresh_token', ''),
              );

          if (refreshCookie.value.isNotEmpty) {
            await _secureStorage.write(
              key: 'refresh_token',
              value: refreshCookie.value,
            );
            debugPrint('Refresh token đã lưu trong SecureStorage');
          } else {
            throw Exception('Không tìm thấy refresh_token trong header');
          }
        }

        // Lưu trạng thái user
        final userData = data['account'] ?? {};
        final isActiveValue = userData['is_active'] ?? 0;
        await _secureStorage.write(
          key: 'is_active',
          value: isActiveValue.toString(),
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
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('Không tìm thấy refresh token trong SecureStorage');
      }

      final response = await apiClient.publicDio.get(
        '/auth/refresh',
        options: Options(headers: {'Cookie': 'refresh_token=$refreshToken'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        final newAccessToken = data['access_token'];

        await _secureStorage.write(key: 'access_token', value: newAccessToken);
        debugPrint('✅ Access token đã được làm mới và lưu');
        final token = await _secureStorage.read(key: 'access_token');
        debugPrint('🔑 [InitScreen] New access token: $token');

        final setCookieHeader = response.headers['set-cookie'];
        if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
          final newRefresh = setCookieHeader
              .map((str) => Cookie.fromSetCookieValue(str))
              .firstWhere(
                (c) => c.name == 'refresh_token',
                orElse: () => Cookie('refresh_token', ''),
              );

          if (newRefresh.value.isNotEmpty) {
            await _secureStorage.write(
              key: 'refresh_token',
              value: newRefresh.value,
            );
            debugPrint('✅ Refresh token mới đã lưu');
            final refresh = await _secureStorage.read(key: 'refresh_token');
            debugPrint('🔑 [InitScreen] New refresh token: $refresh');
          }
        }

        return {
          'token': newAccessToken,
          'user': data['user'] ?? {},
          'isActive': (data['user']?['is_active'] ?? 0) == 1,
          'success': true,
        };
      } else {
        throw Exception('Làm mới token thất bại');
      }
    } catch (e) {
      debugPrint('❌ Refresh token error: $e');
      throw Exception('Không thể làm mới token, vui lòng đăng nhập lại.');
    }
  }

  // ==================== XỬ LÝ HẾT HẠN TOKEN ====================
  Future<void> handleTokenExpired() async {
    await _secureStorage.deleteAll();
    debugPrint('❌ Phiên đăng nhập hết hạn, vui lòng đăng nhập lại.');
    _onTokenExpiredController.add(null);
  }

  // ==================== DỌN DẸP ====================
  Future<void> _cleanupLocalData() async {
    await _secureStorage.deleteAll();
    debugPrint(
      '🧹 [AuthService] Đã xóa access token + refresh token + user data',
    );
  }

  // ==================== LOGOUT ====================
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await apiClient.privateDio.post('/auth/logout');

      if (response.statusCode == 200) {
        await _cleanupLocalData();
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

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await apiClient.publicDio.post(
        '/auth/register',
        data: {
          "username": name,
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

  Future<Map<String, dynamic>> sendActivationCode() async {
    try {
      final response = await apiClient.privateDio.post('/auth/send-code');

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
      final response = await apiClient.privateDio.post(
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

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await apiClient.publicDio.post(
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
      final response = await apiClient.publicDio.post(
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
}
