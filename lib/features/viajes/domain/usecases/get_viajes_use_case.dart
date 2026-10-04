import '../entities/viaje_entity.dart';
import '../repositories/viajes_repository.dart';

class GetViajesUseCase {
  final ViajesRepository repository;

  GetViajesUseCase(this.repository);

  Future<List<ViajeEntity>> call({
    String? fechaInicio,
    String? fechaFin,
  }) {
    return repository.getViajes(
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
