import '../../domain/entities/viaje_entity.dart';
import '../../domain/repositories/viajes_repository.dart';
import '../datasources/viajes_remote_data_source.dart';

class ViajesRepositoryImpl implements ViajesRepository {
  final ViajesRemoteDataSource remoteDataSource;

  ViajesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ViajeEntity>> getViajes({
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final models = await remoteDataSource.getViajes(
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
