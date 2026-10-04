import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guias_transportista/features/guias/domain/entities/config_entity.dart';
import 'package:guias_transportista/features/guias/domain/usecases/emitir_guia_use_case.dart';
import 'package:guias_transportista/features/guias/domain/usecases/get_configuracion_use_case.dart';
import 'package:guias_transportista/features/guias/presentation/cubit/guia_create_cubit.dart';
import 'package:guias_transportista/features/guias/presentation/cubit/guia_create_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConfiguracionUseCase extends Mock
    implements GetConfiguracionUseCase {}

class MockEmitirGuiaUseCase extends Mock implements EmitirGuiaUseCase {}

void main() {
  late MockGetConfiguracionUseCase mockGetConfiguracionUseCase;
  late MockEmitirGuiaUseCase mockEmitirGuiaUseCase;
  late GuiaCreateCubit cubit;

  const testConfig = ClienteConfigEntity(
    idCliente: 'CLI-01',
    razonSocial: 'ACEROS AREQUIPA S.A.',
    ruc: '20100010001',
    remitentes: [
      RemitenteConfigEntity(
        idRemitente: 'REM-01',
        razonSocial: 'PLANTA PISCO',
        ruc: '20100010001',
        destinatarios: [
          DestinatarioConfigEntity(
            idDestinatario: 'DEST-01',
            razonSocial: 'CONSTRUCTORA GRAÑA',
            ruc: '20200020002',
            direccionesPartida: [
              DireccionPartidaConfigEntity(
                idDireccionPartida: 'DIR-P-01',
                direccion: 'KM 240 PANAMERICANA SUR',
                ubigeo: '110501',
                direccionesDestino: [
                  DireccionDestinoConfigEntity(
                    idDireccionDestino: 'DIR-D-01',
                    direccion: 'AV. JAVIER PRADO ESTE 4200',
                    ubigeo: '150130',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  setUp(() {
    mockGetConfiguracionUseCase = MockGetConfiguracionUseCase();
    mockEmitirGuiaUseCase = MockEmitirGuiaUseCase();
    cubit = GuiaCreateCubit(
      getConfiguracionUseCase: mockGetConfiguracionUseCase,
      emitirGuiaUseCase: mockEmitirGuiaUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('GuiaCreateCubit Tests', () {
    test('initial state is GuiaCreateInitial', () {
      expect(cubit.state, equals(GuiaCreateInitial()));
    });

    blocTest<GuiaCreateCubit, GuiaCreateState>(
      'loads configuration and pre-populates cascade selections',
      build: () {
        when(() => mockGetConfiguracionUseCase(
              idProgramacion: '101',
              idCliente: null,
            )).thenAnswer((_) async => testConfig);
        return cubit;
      },
      act: (c) => c.loadConfig(idProgramacion: '101'),
      expect: () => [
        GuiaCreateLoadingConfig(),
        isA<GuiaCreateFormState>()
            .having((s) => s.config, 'config', testConfig)
            .having((s) => s.selectedRemitente?.idRemitente, 'remitente', 'REM-01')
            .having((s) => s.selectedDestinatario?.idDestinatario, 'destinatario', 'DEST-01')
            .having((s) => s.selectedDireccionPartida?.idDireccionPartida, 'partida', 'DIR-P-01')
            .having((s) => s.selectedDireccionDestino?.idDireccionDestino, 'destino', 'DIR-D-01'),
      ],
    );

    test('addDocumentoRelacionado adds series and updates accumulated weight', () async {
      when(() => mockGetConfiguracionUseCase(
            idProgramacion: '101',
            idCliente: null,
          )).thenAnswer((_) async => testConfig);

      await cubit.loadConfig(idProgramacion: '101');

      final added1 = cubit.addDocumentoRelacionado(
        serie: 'EG01',
        numero: '0000452',
        pesoKg: 15000.5000,
      );
      expect(added1, isTrue);

      final state1 = cubit.state as GuiaCreateFormState;
      expect(state1.documentosRelacionados.length, equals(1));
      expect(state1.pesoTotalKg, equals(15000.5000));

      // Try adding duplicate
      final addedDuplicate = cubit.addDocumentoRelacionado(
        serie: 'EG01',
        numero: '0000452',
        pesoKg: 5000.0,
      );
      expect(addedDuplicate, isFalse);

      // Add second item
      final added2 = cubit.addDocumentoRelacionado(
        serie: 'EG01',
        numero: '0000453',
        pesoKg: 12000.0000,
      );
      expect(added2, isTrue);

      final state2 = cubit.state as GuiaCreateFormState;
      expect(state2.documentosRelacionados.length, equals(2));
      expect(state2.pesoTotalKg, equals(27000.5000));
      expect(state2.isValid, isTrue);
    });
  });
}
