import 'package:auth/src/app.dart';
import 'package:auth/src/auth/models/tokens.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class AuthInterceptor extends Interceptor {
  Dio api;

  AuthInterceptor(this.api);

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final context = MyApp.materialKey.currentContext;

    if (context == null) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final accessToken = await authProvider.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (err.response?.statusCode == 401 &&
        await authProvider.getRefreshToken() != null) {
      return _handlerRefreshToken(authProvider, err, handler);
    }

    return super.onError(err, handler);
  }

  _handlerRefreshToken(
    AuthProvider authProvider,
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    if (requestOptions.headers.containsKey('skipRefreshToken')) {
      return super.onError(err, handler);
    }

    final refreshToken = await authProvider.getRefreshToken();

    try {
      final response = await api.post(
        '/auth/refresh-token',
        data: {
          'refreshToken': refreshToken,
        },
        options: Options(
          headers: {
            'skipRefreshToken': true,
          },
        ),
      );

      final tokens = Tokens.fromJson(response.data);

      await authProvider.setTokens(tokens);

      try {
        final headers = requestOptions.headers;

        headers['skipRefreshToken'] = true;

        final finalResponse = await api.request(
          requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: headers,
          ),
        );

        return handler.resolve(finalResponse);
      } on DioError catch (e) {
        return handler.next(e);
      } catch (e) {
        return super.onError(err, handler);
      }
    } catch (e) {
      authProvider.logout(false);
    }
  }
}
