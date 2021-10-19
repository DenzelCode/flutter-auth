import 'package:auth/src/app.dart';
import 'package:auth/src/features/auth/logic/interceptors/auth_token_interceptor.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/shared/views/widgets/dialog/alert_dialog_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorDialogInterceptor extends Interceptor {
  static const skipHeader = 'skipDialog';

  @override
  onError(DioError err, ErrorInterceptorHandler handler) async {
    final context = application.currentContext;

    if (context == null) {
      return;
    }

    final data = err.response?.data;

    final repository = context.read<AuthRepository>();

    if (data == null ||
        !(data is Map) ||
        err.response?.statusCode == 401 &&
            await repository.getRefreshToken() != null &&
            !err.requestOptions.headers
                .containsKey(AuthTokenInterceptor.skipHeader)) {
      return super.onError(err, handler);
    }

    if (!err.requestOptions.headers.containsKey(skipHeader)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          title: data['error'] ?? data['message'],
          description: data['message'],
        ),
      );
    }

    return super.onError(err, handler);
  }
}
