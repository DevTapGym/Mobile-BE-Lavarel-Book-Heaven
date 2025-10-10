import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';
import 'api_client.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final FlutterSecureStorage _secureStorage;
  late final AuthService _authService;
  late final ApiClient _apiClient;

  void initialize() {
    _secureStorage = const FlutterSecureStorage();
    _authService = AuthService._internal();
    _apiClient = ApiClient(_secureStorage, _authService);
    _authService._setApiClient(_apiClient);
  }

  AuthService get authService => _authService;
  ApiClient get apiClient => _apiClient;
  FlutterSecureStorage get secureStorage => _secureStorage;
}