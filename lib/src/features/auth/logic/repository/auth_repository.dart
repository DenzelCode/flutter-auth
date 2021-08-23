import 'dart:async';
import 'dart:io';

import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/features/auth/logic/models/tokens.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/logic/provider/auth_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as store;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  late final _storage = new store.FlutterSecureStorage();

  final _provider = AuthAPIProvider();

  late final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  String getDeviceName() {
    String type = 'web';

    if (Platform.isIOS) {
      type = 'ios';
    }

    if (Platform.isAndroid) {
      type = 'android';
    }

    return type;
  }

  Future<void> logout() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  Future<User?> getProfile() async {
    if (await getAccessToken() == null && await getRefreshToken() == null) {
      return null;
    }

    try {
      return _provider.getProfile();
    } catch (e) {
      return null;
    }
  }

  Future<void> authenticate(String username, String password) async {
    return setTokens(
      await _provider.authenticate(username, password),
    );
  }

  Future<void> register(String username, String password, String email) async {
    return setTokens(
      await _provider.register(username, password, email),
    );
  }

  Future<void> loginWithFacebook() async {
    await FacebookAuth.instance.logOut();

    final result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      return setTokens(
        await _provider.loginWithFacebook(result.accessToken?.token),
      );
    } else {
      throw Exception(result.message);
    }
  }

  Future<void> loginWithApple() async {
    if (!await SignInWithApple.isAvailable()) {
      throw new Exception('Apple login is not available');
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

    return setTokens(
      await _provider.loginWithApple(
        identityToken: result.identityToken,
        authorizationCode: result.authorizationCode,
        givenName: result.givenName,
        familyName: result.familyName,
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    await _googleSignIn.signOut();

    final result = await _googleSignIn.signIn();

    if (result == null) {
      throw Exception('An error occurred authenticating with Google');
    }

    final authentication = await result.authentication;

    return setTokens(
      await _provider.loginWithGoogle(authentication.accessToken),
    );
  }

  Future<void> recover(String email) {
    return _provider.recover(email);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: 'accessToken');
  }

  Future<void> setAccessToken(String token) {
    return _storage.write(key: 'accessToken', value: token);
  }

  Future<void> deleteAccessToken() {
    return _storage.delete(key: 'accessToken');
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: 'refreshToken');
  }

  Future<void> setRefreshToken(String token) {
    return _storage.write(key: 'refreshToken', value: token);
  }

  Future<void> deleteRefreshToken() {
    return _storage.delete(key: 'refreshToken');
  }

  Future<void> setTokens(Tokens tokens) async {
    await setAccessToken(tokens.accessToken);
    await setRefreshToken(tokens.refreshToken);
  }
}
