import 'package:auth/src/common/http/interceptors/auth_interceptor.dart';
import 'package:auth/src/common/http/interceptors/dialog_interceptor.dart';
import 'package:auth/src/constants/environments.dart';
import 'package:dio/dio.dart';

export 'package:dio/dio.dart';

Dio _createHttpClient() {
  final api = new Dio(
    new BaseOptions(
      baseUrl: environments.api,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  api.interceptors.add(new DialogInterceptor());
  api.interceptors.add(new AuthInterceptor(api));

  return api;
}

final api = _createHttpClient();
