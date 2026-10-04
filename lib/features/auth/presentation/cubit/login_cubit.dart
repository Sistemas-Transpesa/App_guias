import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final AuthRepository authRepository;

  LoginCubit({
    required this.loginUseCase,
    required this.authRepository,
  }) : super(LoginInitial(initialUsername: authRepository.getRememberUsername()));

  Future<void> login({
    required String username,
    required String password,
    bool remember = true,
  }) async {
    emit(LoginLoading());
    try {
      if (remember) {
        await authRepository.saveRememberUsername(username.trim());
      }
      final user = await loginUseCase(
        username: username.trim(),
        password: password,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(LoginFailure(message));
    }
  }
}
