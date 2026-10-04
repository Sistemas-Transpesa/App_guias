import 'package:equatable/equatable.dart';

abstract class ViajesEvent extends Equatable {
  const ViajesEvent();

  @override
  List<Object?> get props => [];
}

class FetchViajesRequested extends ViajesEvent {
  final String? fechaInicio;
  final String? fechaFin;
  final bool isRefresh;

  const FetchViajesRequested({
    this.fechaInicio,
    this.fechaFin,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [fechaInicio, fechaFin, isRefresh];
}

class FilterViajesByDateRequested extends ViajesEvent {
  final DateTime fechaInicio;
  final DateTime fechaFin;

  const FilterViajesByDateRequested({
    required this.fechaInicio,
    required this.fechaFin,
  });

  @override
  List<Object?> get props => [fechaInicio, fechaFin];
}

class ResetViajesFilterRequested extends ViajesEvent {}
