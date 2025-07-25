import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_exception.dart';
import '../pods/user/user_pod.dart';

part 'api_service.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  return ApiService(ref);
}

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  static const Duration timeout = Duration(seconds: 30);
  
  final http.Client _client = http.Client();
  final Ref _ref;
  
  ApiService(this._ref);

  // GET请求
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    return _executeRequest(() async => _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
    ));
  }

  // POST请求
  Future<Map<String, dynamic>> post(String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(() async => _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    ));
  }

  // PUT请求
  Future<Map<String, dynamic>> put(String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(() async => _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    ));
  }

  // DELETE请求
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    return _executeRequest(() async => _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
    ));
  }

  // 统一的请求执行和错误处理
  Future<Map<String, dynamic>> _executeRequest(Future<Future<http.Response>> Function() request) async {
    try {
      final response = await (await request()).timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('网络连接失败，请检查网络连接');
    } on HttpException catch (e) {
      throw NetworkException('网络请求失败: ${e.message}');
    } on AppException {
      // 如果已经是AppException，直接重新抛出，不要包装
      rethrow;
    } catch (e) {
      throw AppException('请求失败: ${e.toString()}', originalError: e);
    }
  }

  // 构建请求头
  Future<Map<String, String>> _buildHeaders(Map<String, String>? additionalHeaders) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 自动添加认证token
    String? token;
    
    // 首先尝试从UserState获取token
    final userStateAsync = _ref.read(userNotifierProvider);
    final userState = userStateAsync.value;
    
    if (userState != null && userState.isLoggedIn && userState.token != null) {
      token = userState.token;
    } else {
      // 如果UserState中没有token，尝试从本地存储读取
      try {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString('auth_token');
      } catch (e) {
        // 忽略读取错误，继续执行
      }
    }
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  // 处理HTTP响应
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    // 成功响应
    if (statusCode >= 200 && statusCode < 300) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw AppException('响应数据格式错误', originalError: e);
      }
    }

    // 错误响应处理
    final errorData = _parseErrorResponse(response.body);
    final errorMessage = _extractErrorMessage(errorData);

    switch (statusCode) {
      case 400:
      case 422:
        throw ValidationException(
          errorMessage,
          errorData['errors'] ?? <String, String>{},
        );
      case 401:
      case 403:
        throw AuthException(errorMessage);
      case 404:
      case 500:
        throw ServerException(errorMessage, statusCode);
      default:
        throw ServerException(errorMessage, statusCode);
    }
  }

  // 解析错误响应体
  Map<String, dynamic> _parseErrorResponse(String responseBody) {
    try {
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      return {'message': '未知错误'};
    }
  }

  // 提取错误信息 (按优先级: error > message > 默认)
  String _extractErrorMessage(Map<String, dynamic> errorData) {
    return errorData['error']?.toString() ?? 
           errorData['message']?.toString() ?? 
           '请求失败';
  }

  // 释放资源
  void dispose() {
    _client.close();
  }
}