import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/config_entity.dart';
import '../../domain/entities/guia_entity.dart';
import '../../domain/usecases/emitir_guia_use_case.dart';
import '../../domain/usecases/get_configuracion_use_case.dart';
import 'guia_create_state.dart';

class GuiaCreateCubit extends Cubit<GuiaCreateState> {
  final GetConfiguracionUseCase getConfiguracionUseCase;
  final EmitirGuiaUseCase emitirGuiaUseCase;

  GuiaCreateCubit({
    required this.getConfiguracionUseCase,
    required this.emitirGuiaUseCase,
  }) : super(GuiaCreateInitial());

  Future<void> loadConfig({
    required String idProgramacion,
    String? idCliente,
    bool isTicketMode = false,
  }) async {
    emit(GuiaCreateLoadingConfig());
    try {
      final config = await getConfiguracionUseCase(
        idProgramacion: idProgramacion,
        idCliente: idCliente,
      );

      final remitentes = config.remitentes;
      RemitenteConfigEntity? initialRemitente =
          remitentes.isNotEmpty ? remitentes.first : null;

      final destinatarios =
          initialRemitente != null ? initialRemitente.destinatarios : <DestinatarioConfigEntity>[];
      DestinatarioConfigEntity? initialDestinatario =
          destinatarios.isNotEmpty ? destinatarios.first : null;

      final partidas =
          initialDestinatario != null ? initialDestinatario.direccionesPartida : <DireccionPartidaConfigEntity>[];
      DireccionPartidaConfigEntity? initialPartida =
          partidas.isNotEmpty ? partidas.first : null;

      final destinos =
          initialPartida != null ? initialPartida.direccionesDestino : <DireccionDestinoConfigEntity>[];
      DireccionDestinoConfigEntity? initialDestino =
          destinos.isNotEmpty ? destinos.first : null;

      emit(GuiaCreateFormState(
        config: config,
        remitentes: remitentes,
        selectedRemitente: initialRemitente,
        destinatarios: destinatarios,
        selectedDestinatario: initialDestinatario,
        direccionesPartida: partidas,
        selectedDireccionPartida: initialPartida,
        direccionesDestino: destinos,
        selectedDireccionDestino: initialDestino,
        isTicketMode: isTicketMode,
      ));
    } catch (e) {
      emit(GuiaCreateError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void onRemitenteSelected(RemitenteConfigEntity remitente) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    final destinatarios = remitente.destinatarios;
    final selectedDest = destinatarios.isNotEmpty ? destinatarios.first : null;
    final partidas = selectedDest != null ? selectedDest.direccionesPartida : <DireccionPartidaConfigEntity>[];
    final selectedPartida = partidas.isNotEmpty ? partidas.first : null;
    final destinos = selectedPartida != null ? selectedPartida.direccionesDestino : <DireccionDestinoConfigEntity>[];
    final selectedDestino = destinos.isNotEmpty ? destinos.first : null;

    emit(currentState.copyWith(
      selectedRemitente: remitente,
      destinatarios: destinatarios,
      selectedDestinatario: selectedDest,
      direccionesPartida: partidas,
      selectedDireccionPartida: selectedPartida,
      direccionesDestino: destinos,
      selectedDireccionDestino: selectedDestino,
      clearError: true,
    ));
  }

  void onDestinatarioSelected(DestinatarioConfigEntity destinatario) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    final partidas = destinatario.direccionesPartida;
    final selectedPartida = partidas.isNotEmpty ? partidas.first : null;
    final destinos = selectedPartida != null ? selectedPartida.direccionesDestino : <DireccionDestinoConfigEntity>[];
    final selectedDestino = destinos.isNotEmpty ? destinos.first : null;

    emit(currentState.copyWith(
      selectedDestinatario: destinatario,
      direccionesPartida: partidas,
      selectedDireccionPartida: selectedPartida,
      direccionesDestino: destinos,
      selectedDireccionDestino: selectedDestino,
      clearError: true,
    ));
  }

  void onDireccionPartidaSelected(DireccionPartidaConfigEntity partida) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    final destinos = partida.direccionesDestino;
    final selectedDestino = destinos.isNotEmpty ? destinos.first : null;

    emit(currentState.copyWith(
      selectedDireccionPartida: partida,
      direccionesDestino: destinos,
      selectedDireccionDestino: selectedDestino,
      clearError: true,
    ));
  }

  void onDireccionDestinoSelected(DireccionDestinoConfigEntity destino) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    emit(currentState.copyWith(
      selectedDireccionDestino: destino,
      clearError: true,
    ));
  }

  void setTicketMode(bool isTicket) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;
    emit(currentState.copyWith(isTicketMode: isTicket));
  }

  void setObservacion(String obs) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;
    emit(currentState.copyWith(observacion: obs));
  }

  bool addDocumentoRelacionado({
    required String serie,
    required String numero,
    required double pesoKg,
  }) {
    if (state is! GuiaCreateFormState) return false;
    final currentState = state as GuiaCreateFormState;

    final cleanSerie = serie.trim().toUpperCase();
    final cleanNumero = numero.trim();

    // Check duplicate
    final exists = currentState.documentosRelacionados.any(
      (doc) =>
          doc.serie.toUpperCase() == cleanSerie &&
          doc.numero == cleanNumero,
    );

    if (exists) {
      emit(currentState.copyWith(
        errorMessage: 'El documento $cleanSerie-$cleanNumero ya ha sido agregado.',
      ));
      return false;
    }

    final newDoc = DocumentoRelacionadoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipoDocumento: currentState.isTicketMode ? 'TICKET' : 'GUIA_REMITENTE',
      serie: cleanSerie,
      numero: cleanNumero,
      pesoKg: pesoKg,
    );

    final updatedList = List<DocumentoRelacionadoEntity>.from(
        currentState.documentosRelacionados)..add(newDoc);

    // Sum weights automatically
    final totalWeight = updatedList.fold<double>(0.0, (sum, d) => sum + d.pesoKg);

    emit(currentState.copyWith(
      documentosRelacionados: updatedList,
      pesoTotalKg: totalWeight,
      clearError: true,
    ));
    return true;
  }

  void removeDocumentoRelacionado(String docId) {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    final updatedList = currentState.documentosRelacionados
        .where((d) => d.id != docId)
        .toList();

    final totalWeight = updatedList.fold<double>(0.0, (sum, d) => sum + d.pesoKg);

    emit(currentState.copyWith(
      documentosRelacionados: updatedList,
      pesoTotalKg: totalWeight,
      clearError: true,
    ));
  }

  Future<void> submit({required String idProgramacion}) async {
    if (state is! GuiaCreateFormState) return;
    final currentState = state as GuiaCreateFormState;

    if (!currentState.isValid) {
      emit(currentState.copyWith(
        errorMessage: 'Complete todos los campos requeridos y agregue al menos un documento con peso.',
      ));
      return;
    }

    emit(currentState.copyWith(isSubmitting: true, clearError: true));

    try {
      final guia = await emitirGuiaUseCase(
        idProgramacion: idProgramacion,
        idRemitente: currentState.selectedRemitente!.idRemitente,
        idDestinatario: currentState.selectedDestinatario!.idDestinatario,
        idDireccionPartida:
            currentState.selectedDireccionPartida!.idDireccionPartida,
        idDireccionDestino:
            currentState.selectedDireccionDestino!.idDireccionDestino,
        pesoTotalKg: currentState.pesoTotalKg,
        isTicketMode: currentState.isTicketMode,
        documentos: currentState.documentosRelacionados,
        observacion: currentState.observacion,
      );

      emit(GuiaCreateSuccess(guia));
    } catch (e) {
      emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
