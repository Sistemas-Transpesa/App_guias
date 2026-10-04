import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthUserLoggedIn>(_onUserLoggedIn);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isAuth = await getCurrentUserUseCase.isAuthenticated();
      if (isAuth) {
        final user = await getCurrentUserUseCase();
        if (user != null) {
          emit(Authenticated(user));
          return;
        }
      }
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  void _onUserLoggedIn(
    AuthUserLoggedIn event,
    Emitter<AuthState> emit,
  ) {
    emit(Authenticated(event.user));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
    } catch (_) {}
    emit(Unauthenticated());
  }
}
