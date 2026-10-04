import 'package:equatable/equatable.dart';

abstract class GuiasEvent extends Equatable {
  const GuiasEvent();

  @override
  List<Object?> get props => [];
}

class FetchGuiasRequested extends GuiasEvent {
  final String idProgramacion;
  final bool isSilentRefresh; // Silent refresh for 2-minute periodic polling

  const FetchGuiasRequested({
    required this.idProgramacion,
    this.isSilentRefresh = false,
  });

  @override
  List<Object?> get props => [idProgramacion, isSilentRefresh];
}

class StartGuiasPollingRequested extends GuiasEvent {
  final String idProgramacion;

  const StartGuiasPollingRequested({required this.idProgramacion});

  @override
  List<Object?> get props => [idProgramacion];
}

class StopGuiasPollingRequested extends GuiasEvent {}

class DownloadGuiaPdfRequested extends GuiasEvent {
  final String idGuia;
  final String numeroGuia;
  final String? directUrl;

  const DownloadGuiaPdfRequested({
    required this.idGuia,
    required this.numeroGuia,
    this.directUrl,
  });

  @override
  List<Object?> get props => [idGuia, numeroGuia, directUrl];
}

class FetchSunatMensajeRequested extends GuiasEvent {
  final String idGuia;

  const FetchSunatMensajeRequested({required this.idGuia});

  @override
  List<Object?> get props => [idGuia];
}
