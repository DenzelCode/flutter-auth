import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<User?> {
  AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(null);

  Future<void> authenticate(String username, String password) async {
    await authRepository.authenticate(username, password);

    await updateProfile();
  }

  Future<void> logout() async {
    await authRepository.logout();

    emit(null);
  }

  Future<void> updateProfile() async {
    emit(await this.authRepository.getProfile());
  }
}
