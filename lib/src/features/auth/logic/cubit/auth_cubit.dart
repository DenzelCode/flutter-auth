import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/features/notification/logic/repository/notification_repository.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<User?> {
  AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(null);

  Future<void> authenticate(String username, String password) async {
    return _loginWith(() => authRepository.authenticate(username, password));
  }

  Future<void> register(String username, String password, String email) async {
    return _loginWith(() => authRepository.register(username, password, email));
  }

  Future<void> loginWithFacebook() async {
    return _loginWith(() => authRepository.loginWithFacebook());
  }

  Future<void> loginWithGoogle() async {
    return _loginWith(() => authRepository.loginWithGoogle());
  }

  Future<void> loginWithApple() async {
    return _loginWith(() => authRepository.loginWithApple());
  }

  Future<void> _loginWith(Function method) async {
    await method();

    return updateProfile();
  }

  Future<void> logout() async {
    await notificationRepository.deleteSubscription();

    await authRepository.logout();

    emit(null);
  }

  Future<void> updateProfile() async {
    emit(await this.authRepository.getProfile());
  }
}
