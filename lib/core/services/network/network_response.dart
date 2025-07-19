part of 'network_client.dart';

class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.responseData,
    this.errorMessage,
  });
}
