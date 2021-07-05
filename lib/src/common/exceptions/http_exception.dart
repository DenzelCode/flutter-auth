import 'dart:convert';

class HttpException implements Exception {
  late int statusCode;
  late dynamic message;
  late String? error;

  HttpException({
    required this.message,
    required this.statusCode,
    required this.error,
  });

  factory HttpException.fromString(String string) {
    final decoded = json.decode(string);

    return HttpException.fromJson(decoded);
  }

  HttpException.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
  }
}
