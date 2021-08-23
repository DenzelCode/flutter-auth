import 'package:auth/src/app.dart';
import 'package:auth/src/shared/views/widgets/alert_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DialogInterceptor extends Interceptor {
  static const skipHeader = 'skipDialog';

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

    if (!err.requestOptions.headers.containsKey(skipHeader)) {
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
