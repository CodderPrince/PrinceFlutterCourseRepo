import 'dart:convert';
import 'dart:ui';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

part 'network_response.dart';

class NetworkClient {
  final String _defaultErrorMsg = 'Something went wrong';

  final VoidCallback onUnAuthorize;

  final Logger _logger = Logger();

  NetworkClient({required this.onUnAuthorize});

  Future<NetworkResponse> getRequest({required String url}) async {
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'token': Get.find<AuthController>().accessToken ?? '',
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders);
      final http.Response response = await http.get(
        uri,
        headers: commonHeaders,
      );
      _logResponse(response: response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['msg'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'token': Get.find<AuthController>().accessToken ?? '',
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders);
      final http.Response response = await http.post(
        uri,
        headers: commonHeaders,
        body: jsonEncode(body),
      );
      _logResponse(response: response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['msg'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(String url) async {
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'token': Get.find<AuthController>().accessToken ?? '',
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders);
      final http.Response response = await http.delete(
        uri,
        headers: commonHeaders,
      );
      _logResponse(response: response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['msg'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    final String message = '''
    URL -> $url
    HEADERS -> $headers
    BODY -> $body
    ''';
    _logger.i(message);
  }

  void _logResponse({required http.Response response}) {
    final String message = '''
    URL -> ${response.request?.url}
    HEADERS -> ${response.request?.headers}
    BODY -> ${response.body}
    ''';
    _logger.i(message);
  }
}
