import 'package:equatable/equatable.dart';
import '../../domain/entities/guia_entity.dart';
import '../../domain/entities/sunat_mensaje_entity.dart';

abstract class GuiasState extends Equatable {
  const GuiasState();

  @override
  List<Object?> get props => [];
}

class GuiasInitial extends GuiasState {}

class GuiasLoading extends GuiasState {}

class GuiasLoaded extends GuiasState {
  final List<GuiaEntity> guias;
  final DateTime lastUpdated;
  final bool isPollingActive;
  final String? downloadingGuiaId;
  final String? downloadedPdfPath;
  final SunatMensajeEntity? activeSunatMensaje;

  const GuiasLoaded({
    required this.guias,
    required this.lastUpdated,
    this.isPollingActive = false,
    this.downloadingGuiaId,
    this.downloadedPdfPath,
    this.activeSunatMensaje,
  });

  GuiasLoaded copyWith({
    List<GuiaEntity>? guias,
    DateTime? lastUpdated,
    bool? isPollingActive,
    String? downloadingGuiaId,
    String? downloadedPdfPath,
    SunatMensajeEntity? activeSunatMensaje,
    bool clearDownloading = false,
    bool clearSunatMensaje = false,
  }) {
    return GuiasLoaded(
      guias: guias ?? this.guias,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPollingActive: isPollingActive ?? this.isPollingActive,
      downloadingGuiaId:
          clearDownloading ? null : (downloadingGuiaId ?? this.downloadingGuiaId),
      downloadedPdfPath: downloadedPdfPath ?? this.downloadedPdfPath,
      activeSunatMensaje:
          clearSunatMensaje ? null : (activeSunatMensaje ?? this.activeSunatMensaje),
    );
  }

  @override
  List<Object?> get props => [
        guias,
        lastUpdated,
        isPollingActive,
        downloadingGuiaId,
        downloadedPdfPath,
        activeSunatMensaje,
      ];
}

class GuiasError extends GuiasState {
  final String message;

  const GuiasError(this.message);

  @override
  List<Object?> get props => [message];
}
