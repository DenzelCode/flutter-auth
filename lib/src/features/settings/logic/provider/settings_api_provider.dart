import 'package:auth/src/shared/logic/http/api.dart';

class SettingsAPIProvider {
  Future<void> updateUsername(String username) async {
    await api.put('/settings/username', data: {'username': username});
  }

  Future<void> updateEmail(String email) async {
    await api.put('/settings/email', data: {'email': email});
  }

  Future<void> updatePassword(
    String currentPassword,
    String password,
    String confirmPassword,
  ) async {
    await api.put('/settings/password', data: {
      'currentPassword': currentPassword,
      'password': password,
      'confirmPassword': confirmPassword
    });
  }
}
