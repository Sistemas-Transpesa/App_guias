import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guias_transportista/features/auth/domain/entities/usuario_entity.dart';
import 'package:guias_transportista/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:guias_transportista/features/auth/domain/usecases/logout_use_case.dart';
import 'package:guias_transportista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guias_transportista/features/auth/presentation/bloc/auth_event.dart';
import 'package:guias_transportista/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthBloc authBloc;

  const testUser = UsuarioEntity(
    id: '1',
    username: '45892147',
    nombre: 'Juan Pérez Conductor',
    dni: '45892147',
    token: 'jwt_test_token_123',
    reference: 'CH-009',
  );

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authBloc = AuthBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when user is authenticated with valid session',
      build: () {
        when(() => mockGetCurrentUserUseCase.isAuthenticated())
            .thenAnswer((_) async => true);
        when(() => mockGetCurrentUserUseCase())
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckStatusRequested()),
      expect: () => [
        AuthLoading(),
        const Authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when user is not authenticated',
      build: () {
        when(() => mockGetCurrentUserUseCase.isAuthenticated())
            .thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckStatusRequested()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] on AuthLogoutRequested',
      build: () {
        when(() => mockLogoutUseCase()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
    );
  });
}
