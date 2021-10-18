import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/shared/logic/http/api.dart';

class UserAPIProvider {
  Future<User> getUser(String username) async {
    final response = await api.get('/user/$username');

    return User.fromJson(response.data);
  }
}
