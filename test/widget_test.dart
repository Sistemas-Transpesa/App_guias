import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guias_transportista/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:guias_transportista/features/auth/domain/usecases/logout_use_case.dart';
import 'package:guias_transportista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guias_transportista/features/auth/presentation/screens/splash_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthBloc authBloc;

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
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

  testWidgets('SplashScreen renders Transpesa branding elements', (WidgetTester tester) async {
    when(() => mockGetCurrentUserUseCase.isAuthenticated())
        .thenAnswer((_) async => false);

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    // Initial frame rendering
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('TRANSPESA'), findsOneWidget);
    expect(find.text('GUÍAS TRANSPORTISTA'), findsOneWidget);
    expect(find.text('Versión 2.0 • SUNAT Integrada'), findsOneWidget);

    // Advance clock to finish all pending timers & animations
    await tester.pump(const Duration(seconds: 3));
  });
}
