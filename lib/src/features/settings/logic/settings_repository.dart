import 'package:auth/src/app.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/features/settings/logic/provider/settings_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsRepository {
  final _provider = SettingsAPIProvider();

  Future<void> updateUsername(String username) async {
    return _provider.updateUsername(username);
  }

  Future<void> updateEmail(String email) async {
    return _provider.updateEmail(email);
  }

  Future<void> updatePassword(
    String currentPassword,
    String password,
    String confirmPassword,
  ) async {
    return _provider.updatePassword(currentPassword, password, confirmPassword);
  }
}
