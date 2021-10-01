import 'package:auth/src/features/auth/logic/interceptors/auth_token_interceptor.dart';
import 'package:auth/src/features/auth/logic/models/tokens.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/shared/logic/http/api.dart';
import 'package:auth/src/shared/logic/http/interceptors/dialog_interceptor.dart';

class AuthAPIProvider {
  Future<Tokens> authenticate(String username, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    final tokens = Tokens.fromJson(response.data);

    return tokens;
  }

  Future<Tokens> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await api.post(
      '/auth/register',
      data: {
        'username': username,
        'password': password,
        'email': email,
      },
    );

    final tokens = Tokens.fromJson(response.data);

    return tokens;
  }

  Future<void> recover(String email) async {
    await api.post(
      '/recover',
      data: {
        'email': email,
      },
    );
  }

  Future<User?> getProfile() async {
    final response = await api.get(
      '/auth/me',
      options: Options(
        headers: {
          DialogInterceptor.skipHeader: true,
        },
      ),
    );

    return User.fromJson(response.data);
  }

  Future<Tokens> loginWithFacebook(String? accessToken) {
    return _socialLogin(
      provider: 'facebook',
      accessToken: accessToken,
    );
  }

  Future<Tokens> loginWithGoogle(String? accessToken) {
    return _socialLogin(
      provider: 'google',
      accessToken: accessToken,
    );
  }

  Future<Tokens> loginWithApple({
    required String? identityToken,
    required String authorizationCode,
    String? givenName,
    String? familyName,
    String? type,
  }) {
    return _socialLogin(
      provider: 'apple',
      accessToken: identityToken,
      authorizationCode: authorizationCode,
      type: type,
      name: '$givenName $familyName',
    );
  }

  Future<Tokens> _socialLogin({
    required String provider,
    required String? accessToken,
    String? authorizationCode,
    String? type,
    String? name,
  }) async {
    final response = await api.post(
      '/auth/$provider-login',
      data: {
        'name': name,
        'accessToken': accessToken,
        'authorizationCode': authorizationCode,
        'type': type,
      },
    );

    return Tokens.fromJson(response.data);
  }

  Future<Tokens> loginWithRefreshToken(String? refreshToken) async {
    final response = await api.post(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
      options: Options(headers: {AuthTokenInterceptor.skipHeader: true}),
    );

    return Tokens.fromJson(response.data);
  }
}
