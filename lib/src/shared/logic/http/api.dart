import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/features/auth/logic/interceptors/auth_token_interceptor.dart';
import 'package:auth/src/shared/logic/http/interceptors/dialog_interceptor.dart';
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

  api
    ..interceptors.add(new DialogInterceptor())
    ..interceptors.add(new AuthTokenInterceptor(api));

  return api;
}

final api = _createHttpClient();
