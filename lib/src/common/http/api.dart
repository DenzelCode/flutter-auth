import 'package:auth/src/common/http/custom_interceptor.dart';
import 'package:auth/src/constants/environments.dart';
import 'package:dio/dio.dart';

Dio _createHttpClient() {
  return new Dio(
    new BaseOptions(
      baseUrl: environments.api,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  )..interceptors.add(new CustomInterceptor());
}

final api = _createHttpClient();
