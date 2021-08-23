import 'dart:io';

import 'package:auth/src/features/auth/logic/models/tokens.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/views/screens/login_screen.dart';
import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/shared/logic/http/api.dart';
import 'package:auth/src/shared/logic/http/interceptors/dialog_interceptor.dart';
import 'package:auth/src/shared/views/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as store;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider extends ChangeNotifier {
  User? user;

  late final storage = new store.FlutterSecureStorage();

  late final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<Tokens?> authenticate(String username, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    final tokens = Tokens.fromJson(response.data);

    await setTokens(tokens);

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

    await setTokens(tokens);

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

  Future<void> logout(BuildContext context) async {
    await deleteAccessToken();
    await deleteRefreshToken();

    user = null;

    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (_) => false,
    );
  }

  Future<User?> getProfile() async {
    if (await getAccessToken() == null && await getRefreshToken() == null) {
      return null;
    }

    try {
      final response = await api.get(
        '/auth/me',
        options: Options(
          headers: {
            DialogInterceptor.skipHeader: true,
          },
        ),
      );

      final user = User.fromJson(response.data);

      this.user = user;

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    await FacebookAuth.instance.logOut();

    final result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      await _socialLogin(
        provider: 'facebook',
        accessToken: result.accessToken?.token,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertWidget(
          title: 'Error',
          description: result.message,
        ),
      );

      throw Exception(result.message);
    }
  }

  Future<void> loginWithApple(BuildContext context) async {
    try {
      if (!await SignInWithApple.isAvailable()) {
        showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: 'Error',
            description: 'Sign in with apple is not available on this device',
          ),
        );

        return;
      }

      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: environments.appleSignInClientId,
          redirectUri: environments.appleSignInRedirectUri,
        ),
      );

      await _socialLogin(
        provider: 'apple',
        accessToken: result.identityToken,
        authorizationCode: result.authorizationCode,
        name: '${result.givenName} ${result.familyName}',
      );
    } catch (e) {
      if (!(e is DioError)) {
        showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: 'Error',
            description: 'An error occurred authenticating with Apple',
          ),
        );
      }

      throw Exception(e);
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut();

      final result = await _googleSignIn.signIn();

      if (result == null) {
        throw Exception();
      }

      final authentication = await result.authentication;

      await _socialLogin(
        provider: 'google',
        accessToken: authentication.accessToken,
      );
    } catch (e) {
      if (!(e is DioError)) {
        showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: 'Error',
            description: 'An error occurred authenticating with Google',
          ),
        );
      }

      throw Exception(e);
    }
  }

  Future<void> _socialLogin({
    required String provider,
    required String? accessToken,
    String? authorizationCode,
    String? name,
  }) async {
    final type = Platform.isIOS
        ? 'ios'
        : Platform.isAndroid
            ? 'android'
            : 'web';

    final response = await api.post(
      '/auth/$provider-login',
      data: {
        'name': name,
        'accessToken': accessToken,
        'authorizationCode': authorizationCode,
        'type': type,
      },
    );

    final tokens = Tokens.fromJson(response.data);

    await setTokens(tokens);
  }

  Future<String?> getAccessToken() {
    return storage.read(key: 'accessToken');
  }

  Future<void> setAccessToken(String token) {
    return storage.write(key: 'accessToken', value: token);
  }

  Future<void> deleteAccessToken() {
    return storage.delete(key: 'accessToken');
  }

  Future<String?> getRefreshToken() {
    return storage.read(key: 'refreshToken');
  }

  Future<void> setRefreshToken(String token) {
    return storage.write(key: 'refreshToken', value: token);
  }

  Future<void> deleteRefreshToken() {
    return storage.delete(key: 'refreshToken');
  }

  Future<void> setTokens(Tokens tokens) async {
    await setAccessToken(tokens.accessToken);
    await setRefreshToken(tokens.refreshToken);
  }
}
