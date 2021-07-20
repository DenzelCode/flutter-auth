import 'package:auth/src/auth/models/tokens.dart';
import 'package:auth/src/auth/models/user.dart';
import 'package:auth/src/common/http/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  User? user;

  final storage = new FlutterSecureStorage();

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

  Future<void> logout([bool notify = true]) async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');

    user = null;

    if (notify) {
      notifyListeners();
    }
  }

  Future<User?> getProfile() async {
    if (await getAccessToken() == null && await getRefreshToken() == null) {
      return null;
    }

    try {
      final response = await api.get('/auth/me');

      final user = User.fromJson(response.data);

      this.user = user;

      return user;
    } catch (e) {
      logout(false);

      return null;
    }
  }

  Future<String?> getAccessToken() {
    return storage.read(key: 'accessToken');
  }

  Future<void> setAccessToken(String token) {
    return storage.write(key: 'accessToken', value: token);
  }

  Future<void> deleteAccessToken(String token) {
    return storage.delete(key: 'accessToken');
  }

  Future<String?> getRefreshToken() {
    return storage.read(key: 'refreshToken');
  }

  Future<void> setRefreshToken(String token) {
    return storage.write(key: 'refreshToken', value: token);
  }

  Future<void> deleteRefreshToken(String token) {
    return storage.delete(key: 'refreshToken');
  }

  Future<void> setTokens(Tokens tokens) async {
    await setAccessToken(tokens.accessToken);
    await setRefreshToken(tokens.refreshToken);
  }
}
