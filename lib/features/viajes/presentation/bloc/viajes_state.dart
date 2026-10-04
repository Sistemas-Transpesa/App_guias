import 'package:equatable/equatable.dart';
import '../../domain/entities/viaje_entity.dart';

abstract class ViajesState extends Equatable {
  const ViajesState();

  @override
  List<Object?> get props => [];
}

class ViajesInitial extends ViajesState {}

class ViajesLoading extends ViajesState {}

class ViajesLoaded extends ViajesState {
  final List<ViajeEntity> viajes;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  const ViajesLoaded({
    required this.viajes,
    this.fechaInicio,
    this.fechaFin,
  });

  bool get hasActiveFilter => fechaInicio != null || fechaFin != null;

  @override
  List<Object?> get props => [viajes, fechaInicio, fechaFin];
}

class ViajesError extends ViajesState {
  final String message;

  const ViajesError(this.message);

  @override
  List<Object?> get props => [message];
}
