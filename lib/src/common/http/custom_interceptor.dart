import 'package:auth/src/app.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/alert_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final context = MyApp.materialKey.currentContext;

    if (context == null) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final accessToken = await authProvider.getAccessToken();

    if (accessToken != null) {
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer $accessToken',
      );
    }

    return super.onRequest(options, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) async {
    final context = MyApp.materialKey.currentContext;

    if (context == null) {
      return;
    }

    final response = err.response?.data;

    if (response == null) {
      return super.onError(err, handler);
    }

    if (err.requestOptions.headers['skipDialog'] == null) {
      showDialog(
        context: context,
        builder: (context) => AlertWidget(
          title: response['error'] ?? response['message'],
          description: response['message'],
        ),
      );
    }

    return super.onError(err, handler);
  }
}
