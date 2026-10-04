import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_use_case.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/guias/data/datasources/guias_remote_data_source.dart';
import '../../features/guias/data/repositories/guias_repository_impl.dart';
import '../../features/guias/domain/repositories/guias_repository.dart';
import '../../features/guias/domain/usecases/download_pdf_use_case.dart';
import '../../features/guias/domain/usecases/emitir_guia_use_case.dart';
import '../../features/guias/domain/usecases/get_configuracion_use_case.dart';
import '../../features/guias/domain/usecases/get_guias_use_case.dart';
import '../../features/guias/domain/usecases/get_sunat_mensaje_use_case.dart';
import '../../features/guias/presentation/bloc/guias_bloc.dart';
import '../../features/guias/presentation/cubit/guia_create_cubit.dart';
import '../../features/viajes/data/datasources/viajes_remote_data_source.dart';
import '../../features/viajes/data/repositories/viajes_repository_impl.dart';
import '../../features/viajes/domain/repositories/viajes_repository.dart';
import '../../features/viajes/domain/usecases/get_viajes_use_case.dart';
import '../../features/viajes/presentation/bloc/viajes_bloc.dart';
import '../network/dio_client.dart';
import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ==========================================
  // 1. Storage & External Services
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<PreferencesService>(
    () => PreferencesServiceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );

  // ==========================================
  // 2. Network Client
  // ==========================================
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      secureStorage: sl<SecureStorageService>(),
      onUnauthorized: () {
        // Trigger global logout if token expires
        if (sl.isRegistered<AuthBloc>()) {
          sl<AuthBloc>().add(AuthLogoutRequested());
        }
      },
    ),
  );

  // ==========================================
  // 3. Auth Feature
  // ==========================================
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl<DioClient>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<SecureStorageService>(),
      preferencesService: sl<PreferencesService>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));

  // Blocs & Cubits
  sl.registerLazySingleton(
    () => AuthBloc(
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  sl.registerFactory(
    () => LoginCubit(
      loginUseCase: sl<LoginUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  // ==========================================
  // 4. Viajes Feature
  // ==========================================
  // Data Sources
  sl.registerLazySingleton<ViajesRemoteDataSource>(
    () => ViajesRemoteDataSourceImpl(client: sl<DioClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ViajesRepository>(
    () => ViajesRepositoryImpl(remoteDataSource: sl<ViajesRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetViajesUseCase(sl<ViajesRepository>()));

  // Blocs
  sl.registerFactory(
    () => ViajesBloc(getViajesUseCase: sl<GetViajesUseCase>()),
  );

  // ==========================================
  // 5. Guías Feature
  // ==========================================
  // Data Sources
  sl.registerLazySingleton<GuiasRemoteDataSource>(
    () => GuiasRemoteDataSourceImpl(client: sl<DioClient>()),
  );

  // Repositories
  sl.registerLazySingleton<GuiasRepository>(
    () => GuiasRepositoryImpl(remoteDataSource: sl<GuiasRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetGuiasUseCase(sl<GuiasRepository>()));
  sl.registerLazySingleton(() => GetConfiguracionUseCase(sl<GuiasRepository>()));
  sl.registerLazySingleton(() => EmitirGuiaUseCase(sl<GuiasRepository>()));
  sl.registerLazySingleton(() => GetSunatMensajeUseCase(sl<GuiasRepository>()));
  sl.registerLazySingleton(() => DownloadPdfUseCase(sl<GuiasRepository>()));

  // Blocs & Cubits
  sl.registerFactory(
    () => GuiasBloc(
      getGuiasUseCase: sl<GetGuiasUseCase>(),
      getSunatMensajeUseCase: sl<GetSunatMensajeUseCase>(),
      downloadPdfUseCase: sl<DownloadPdfUseCase>(),
    ),
  );

  sl.registerFactory(
    () => GuiaCreateCubit(
      getConfiguracionUseCase: sl<GetConfiguracionUseCase>(),
      emitirGuiaUseCase: sl<EmitirGuiaUseCase>(),
    ),
  );
}
