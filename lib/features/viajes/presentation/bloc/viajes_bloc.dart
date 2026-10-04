import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/usecases/get_viajes_use_case.dart';
import 'viajes_event.dart';
import 'viajes_state.dart';

class ViajesBloc extends Bloc<ViajesEvent, ViajesState> {
  final GetViajesUseCase getViajesUseCase;

  ViajesBloc({required this.getViajesUseCase}) : super(ViajesInitial()) {
    on<FetchViajesRequested>(_onFetchViajes);
    on<FilterViajesByDateRequested>(_onFilterViajesByDate);
    on<ResetViajesFilterRequested>(_onResetFilter);
  }

  Future<void> _onFetchViajes(
    FetchViajesRequested event,
    Emitter<ViajesState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(ViajesLoading());
    }
    try {
      final viajes = await getViajesUseCase(
        fechaInicio: event.fechaInicio,
        fechaFin: event.fechaFin,
      );
      emit(ViajesLoaded(
        viajes: viajes,
        fechaInicio: DateFormatter.parseDate(event.fechaInicio),
        fechaFin: DateFormatter.parseDate(event.fechaFin),
      ));
    } catch (e) {
      emit(ViajesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onFilterViajesByDate(
    FilterViajesByDateRequested event,
    Emitter<ViajesState> emit,
  ) async {
    emit(ViajesLoading());
    try {
      final fechaInicioStr = DateFormatter.toApiDate(event.fechaInicio);
      final fechaFinStr = DateFormatter.toApiDate(event.fechaFin);

      final viajes = await getViajesUseCase(
        fechaInicio: fechaInicioStr,
        fechaFin: fechaFinStr,
      );

      emit(ViajesLoaded(
        viajes: viajes,
        fechaInicio: event.fechaInicio,
        fechaFin: event.fechaFin,
      ));
    } catch (e) {
      emit(ViajesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onResetFilter(
    ResetViajesFilterRequested event,
    Emitter<ViajesState> emit,
  ) async {
    add(const FetchViajesRequested());
  }
}
