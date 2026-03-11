import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Exception thrown when an API call fails with a non-2xx status code.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? body;

  ApiException(this.statusCode, this.message, [this.body]);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;
  ApiService._();

  final _storage = const FlutterSecureStorage();

  // In-memory token cache to avoid repeated secure-storage reads
  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  Future<String?> _getAccessToken() async {
    return _cachedAccessToken ??= await _storage.read(key: 'access_token');
  }

  Future<String?> _getRefreshToken() async {
    return _cachedRefreshToken ??= await _storage.read(key: 'refresh_token');
  }

  Future<void> setTokens({required String access, required String refresh}) async {
    _cachedAccessToken = access;
    _cachedRefreshToken = refresh;
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _cachedAccessToken = data['access'];
      await _storage.write(key: 'access_token', value: data['access']);
      return true;
    }
    return false;
  }

  Future<Map<String, String>> authHeaders() async {
    final token = await _getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: queryParams);
    var response = await http.get(uri, headers: await authHeaders());

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        response = await http.get(uri, headers: await authHeaders());
      }
    }
    return response;
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    var response = await http.post(uri, headers: await authHeaders(), body: jsonEncode(body));

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        response = await http.post(uri, headers: await authHeaders(), body: jsonEncode(body));
      }
    }
    return response;
  }
}
