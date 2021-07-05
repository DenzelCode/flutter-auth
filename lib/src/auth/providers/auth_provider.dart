import 'dart:convert';
import 'dart:io';

import 'package:auth/src/auth/models/access_token.dart';
import 'package:auth/src/auth/models/user.dart';
import 'package:auth/src/common/exceptions/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  User? user;

  final storage = new FlutterSecureStorage();

  final _url = 'nest-auth.ubbly.club';

  Future<AccessToken> authenticate(String username, String password) async {
    final uri = Uri.https(_url, 'api/auth/login');

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return _handleAuthenticateResponse(response);
  }

  Future<AccessToken> register(
      String username, String email, String password) async {
    final uri = Uri.https(_url, 'api/auth/register');

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    return _handleAuthenticateResponse(response);
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');

    user = null;

    notifyListeners();
  }

  Future<User> getProfile() async {
    final uri = Uri.https(_url, 'api/auth/me');

    final token = await getToken();

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final decoded = json.decode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException.fromJson(decoded));
    }

    final user = User.fromJson(decoded);

    this.user = user;

    return user;
  }

  Future<String?> getToken() {
    return storage.read(key: 'token');
  }

  Future<void> setToken(String token) {
    return storage.write(key: 'token', value: token);
  }

  Future<AccessToken> _handleAuthenticateResponse(
      http.Response response) async {
    final decoded = json.decode(response.body);

    if (response.statusCode != 201) {
      throw HttpException.fromJson(decoded);
    }

    final token = AccessToken.fromJson(decoded);

    await setToken(token.accessToken);

    await getProfile();

    return token;
  }
}
