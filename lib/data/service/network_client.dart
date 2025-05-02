import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../app.dart';
import '../../ui/controller/auth_controller.dart';
import '../../ui/widgets/handel_exception.dart';
import '../../ui/widgets/pop_up_message.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = 'Something went wrong!',
  });
}

class NetworkClient {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Map<String, String> headers = {'token': AuthController.token ?? ''};
      Uri uri = Uri.parse(url);
      _preRequestLog(url: url, headers: headers);
      Response response = await get(uri, headers: headers);
      _postRequestLog(
        response.statusCode,
        url,
        headers: response.headers,
        body: response.body,
      );
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Login Expired!',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      handelException(e);
      _postRequestLog(-1, url);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-type': 'Application/json',
        'token': AuthController.token ?? '',
      };
      _preRequestLog(url: url, body: body, headers: headers);
      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _postRequestLog(
        response.statusCode,
        url,
        body: jsonDecode(response.body),
        headers: response.headers,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Login Expired!',
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson['data'];
        _postRequestLog(-1, url, errorMessage: errorMessage);
        showPopUp(TaskManager.navigatorKey.currentContext, errorMessage, true);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          data: decodedJson,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      handelException(e);
      _postRequestLog(-1, url, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void _preRequestLog({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    _logger.i(
      '++++++ THIS IS FROM PRE REQUEST LOG++++++++'
      'Url => $url\n'
      'Body: ${body ?? ''}\n'
      'Headers ==>> $headers',
    );
  }

  static void _postRequestLog(
    int statusCode,
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    dynamic errorMessage,
  }) {
    if (errorMessage != null) {
      _logger.e(
        ''
        'Url: $url\n'
        'Status code: $statusCode\n'
        'Error Message: $errorMessage',
      );
    } else {
      _logger.i(
        'Url: $url\n'
        'Status code: $statusCode\n'
        'Headers: $headers\n'
        'Response: $body',
      );
    }
  }

  static _moveToLoginScreen() {
    Navigator.pushNamedAndRemoveUntil(
      TaskManager.navigatorKey.currentContext!,
      '/login',
      (route) => false,
    );
    showPopUp(TaskManager.navigatorKey.currentContext, 'Login Expired!');
  }
}
