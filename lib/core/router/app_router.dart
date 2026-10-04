import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/guias/presentation/screens/guias_list_screen.dart';
import '../../features/viajes/domain/entities/viaje_entity.dart';
import '../../features/viajes/presentation/screens/viajes_list_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/viajes',
        name: 'viajes',
        builder: (context, state) => const ViajesListScreen(),
        routes: [
          GoRoute(
            path: ':idProgramacion/guias',
            name: 'guias',
            builder: (context, state) {
              final viaje = state.extra as ViajeEntity? ??
                  ViajeEntity(
                    idProgramacion: state.pathParameters['idProgramacion'] ?? '',
                    codViaje: state.pathParameters['idProgramacion'] ?? '',
                    ruta: 'Ruta Asignada',
                    cliente: 'Cliente',
                    tracto: '-',
                    carreta: '-',
                    conductor: '-',
                    fecha: '',
                  );
              return GuiasListScreen(viaje: viaje);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Página no encontrada: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/viajes'),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
