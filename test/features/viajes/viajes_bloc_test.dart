import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guias_transportista/features/viajes/domain/entities/viaje_entity.dart';
import 'package:guias_transportista/features/viajes/domain/usecases/get_viajes_use_case.dart';
import 'package:guias_transportista/features/viajes/presentation/bloc/viajes_bloc.dart';
import 'package:guias_transportista/features/viajes/presentation/bloc/viajes_event.dart';
import 'package:guias_transportista/features/viajes/presentation/bloc/viajes_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetViajesUseCase extends Mock implements GetViajesUseCase {}

void main() {
  late MockGetViajesUseCase mockGetViajesUseCase;
  late ViajesBloc viajesBloc;

  const testViajes = [
    ViajeEntity(
      idProgramacion: '101',
      codViaje: 'PRG-2026-001',
      ruta: 'LIMA - CALLAO - PISCO',
      cliente: 'ACEROS AREQUIPA S.A.',
      tracto: 'AYZ-981',
      carreta: 'TRP-104',
      conductor: 'Juan Pérez Conductor',
      fecha: '2026-10-05',
      idTipo: '0',
    ),
    ViajeEntity(
      idProgramacion: '102',
      codViaje: 'PRG-2026-002',
      ruta: 'LIMA - CHINCHA',
      cliente: 'MINERA CHOCON S.A.',
      tracto: 'BYZ-550',
      carreta: 'TRP-202',
      conductor: 'Carlos Díaz',
      fecha: '2026-10-05',
      idTipo: '1',
    ),
  ];

  setUp(() {
    mockGetViajesUseCase = MockGetViajesUseCase();
    viajesBloc = ViajesBloc(getViajesUseCase: mockGetViajesUseCase);
  });

  tearDown(() {
    viajesBloc.close();
  });

  group('ViajesBloc Tests', () {
    test('initial state is ViajesInitial', () {
      expect(viajesBloc.state, equals(ViajesInitial()));
    });

    blocTest<ViajesBloc, ViajesState>(
      'emits [ViajesLoading, ViajesLoaded] when FetchViajesRequested succeeds',
      build: () {
        when(() => mockGetViajesUseCase(
              fechaInicio: any(named: 'fechaInicio'),
              fechaFin: any(named: 'fechaFin'),
            )).thenAnswer((_) async => testViajes);
        return viajesBloc;
      },
      act: (bloc) => bloc.add(const FetchViajesRequested()),
      expect: () => [
        ViajesLoading(),
        const ViajesLoaded(
          viajes: testViajes,
          fechaInicio: null,
          fechaFin: null,
        ),
      ],
    );

    blocTest<ViajesBloc, ViajesState>(
      'emits [ViajesLoading, ViajesError] when fetching fails',
      build: () {
        when(() => mockGetViajesUseCase(
              fechaInicio: any(named: 'fechaInicio'),
              fechaFin: any(named: 'fechaFin'),
            )).thenThrow(Exception('Error de conexión con el servidor'));
        return viajesBloc;
      },
      act: (bloc) => bloc.add(const FetchViajesRequested()),
      expect: () => [
        ViajesLoading(),
        const ViajesError('Error de conexión con el servidor'),
      ],
    );
  });
}
