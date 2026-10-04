import 'package:equatable/equatable.dart';
import '../../domain/entities/config_entity.dart';
import '../../domain/entities/guia_entity.dart';

abstract class GuiaCreateState extends Equatable {
  const GuiaCreateState();

  @override
  List<Object?> get props => [];
}

class GuiaCreateInitial extends GuiaCreateState {}

class GuiaCreateLoadingConfig extends GuiaCreateState {}

class GuiaCreateFormState extends GuiaCreateState {
  final ClienteConfigEntity config;
  final RemitenteConfigEntity? selectedRemitente;
  final DestinatarioConfigEntity? selectedDestinatario;
  final DireccionPartidaConfigEntity? selectedDireccionPartida;
  final DireccionDestinoConfigEntity? selectedDireccionDestino;

  final List<RemitenteConfigEntity> remitentes;
  final List<DestinatarioConfigEntity> destinatarios;
  final List<DireccionPartidaConfigEntity> direccionesPartida;
  final List<DireccionDestinoConfigEntity> direccionesDestino;

  final bool isTicketMode;
  final List<DocumentoRelacionadoEntity> documentosRelacionados;
  final double pesoTotalKg;
  final String observacion;

  final bool isSubmitting;
  final String? errorMessage;
  final GuiaEntity? createdGuia;

  const GuiaCreateFormState({
    required this.config,
    this.selectedRemitente,
    this.selectedDestinatario,
    this.selectedDireccionPartida,
    this.selectedDireccionDestino,
    this.remitentes = const [],
    this.destinatarios = const [],
    this.direccionesPartida = const [],
    this.direccionesDestino = const [],
    this.isTicketMode = false,
    this.documentosRelacionados = const [],
    this.pesoTotalKg = 0.0,
    this.observacion = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.createdGuia,
  });

  bool get isValid =>
      selectedRemitente != null &&
      selectedDestinatario != null &&
      selectedDireccionPartida != null &&
      selectedDireccionDestino != null &&
      pesoTotalKg > 0 &&
      documentosRelacionados.isNotEmpty &&
      !isSubmitting;

  GuiaCreateFormState copyWith({
    ClienteConfigEntity? config,
    RemitenteConfigEntity? selectedRemitente,
    DestinatarioConfigEntity? selectedDestinatario,
    DireccionPartidaConfigEntity? selectedDireccionPartida,
    DireccionDestinoConfigEntity? selectedDireccionDestino,
    List<RemitenteConfigEntity>? remitentes,
    List<DestinatarioConfigEntity>? destinatarios,
    List<DireccionPartidaConfigEntity>? direccionesPartida,
    List<DireccionDestinoConfigEntity>? direccionesDestino,
    bool? isTicketMode,
    List<DocumentoRelacionadoEntity>? documentosRelacionados,
    double? pesoTotalKg,
    String? observacion,
    bool? isSubmitting,
    String? errorMessage,
    GuiaEntity? createdGuia,
    bool clearSelectedDestinatario = false,
    bool clearSelectedPartida = false,
    bool clearSelectedDestino = false,
    bool clearError = false,
  }) {
    return GuiaCreateFormState(
      config: config ?? this.config,
      selectedRemitente: selectedRemitente ?? this.selectedRemitente,
      selectedDestinatario: clearSelectedDestinatario
          ? null
          : (selectedDestinatario ?? this.selectedDestinatario),
      selectedDireccionPartida: clearSelectedPartida
          ? null
          : (selectedDireccionPartida ?? this.selectedDireccionPartida),
      selectedDireccionDestino: clearSelectedDestino
          ? null
          : (selectedDireccionDestino ?? this.selectedDireccionDestino),
      remitentes: remitentes ?? this.remitentes,
      destinatarios: destinatarios ?? this.destinatarios,
      direccionesPartida: direccionesPartida ?? this.direccionesPartida,
      direccionesDestino: direccionesDestino ?? this.direccionesDestino,
      isTicketMode: isTicketMode ?? this.isTicketMode,
      documentosRelacionados:
          documentosRelacionados ?? this.documentosRelacionados,
      pesoTotalKg: pesoTotalKg ?? this.pesoTotalKg,
      observacion: observacion ?? this.observacion,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdGuia: createdGuia ?? this.createdGuia,
    );
  }

  @override
  List<Object?> get props => [
        config,
        selectedRemitente,
        selectedDestinatario,
        selectedDireccionPartida,
        selectedDireccionDestino,
        remitentes,
        destinatarios,
        direccionesPartida,
        direccionesDestino,
        isTicketMode,
        documentosRelacionados,
        pesoTotalKg,
        observacion,
        isSubmitting,
        errorMessage,
        createdGuia,
      ];
}

class GuiaCreateError extends GuiaCreateState {
  final String message;

  const GuiaCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

class GuiaCreateSuccess extends GuiaCreateState {
  final GuiaEntity guia;

  const GuiaCreateSuccess(this.guia);

  @override
  List<Object?> get props => [guia];
}
