import '../entities/viaje_entity.dart';

abstract class ViajesRepository {
  Future<List<ViajeEntity>> getViajes({
    String? fechaInicio,
    String? fechaFin,
  });
}
