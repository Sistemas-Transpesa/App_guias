import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/download_pdf_use_case.dart';
import '../../domain/usecases/get_guias_use_case.dart';
import '../../domain/usecases/get_sunat_mensaje_use_case.dart';
import 'guias_event.dart';
import 'guias_state.dart';

class GuiasBloc extends Bloc<GuiasEvent, GuiasState> {
  final GetGuiasUseCase getGuiasUseCase;
  final GetSunatMensajeUseCase getSunatMensajeUseCase;
  final DownloadPdfUseCase downloadPdfUseCase;

  Timer? _pollingTimer;
  String? _currentProgramacionId;

  GuiasBloc({
    required this.getGuiasUseCase,
    required this.getSunatMensajeUseCase,
    required this.downloadPdfUseCase,
  }) : super(GuiasInitial()) {
    on<FetchGuiasRequested>(_onFetchGuias);
    on<StartGuiasPollingRequested>(_onStartPolling);
    on<StopGuiasPollingRequested>(_onStopPolling);
    on<DownloadGuiaPdfRequested>(_onDownloadPdf);
    on<FetchSunatMensajeRequested>(_onFetchSunatMensaje);
  }

  Future<void> _onFetchGuias(
    FetchGuiasRequested event,
    Emitter<GuiasState> emit,
  ) async {
    _currentProgramacionId = event.idProgramacion;

    if (!event.isSilentRefresh && state is! GuiasLoaded) {
      emit(GuiasLoading());
    }

    try {
      final guias = await getGuiasUseCase(idProgramacion: event.idProgramacion);

      if (state is GuiasLoaded) {
        emit((state as GuiasLoaded).copyWith(
          guias: guias,
          lastUpdated: DateTime.now(),
        ));
      } else {
        emit(GuiasLoaded(
          guias: guias,
          lastUpdated: DateTime.now(),
          isPollingActive: _pollingTimer != null,
        ));
      }
    } catch (e) {
      if (state is! GuiasLoaded) {
        emit(GuiasError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  void _onStartPolling(
    StartGuiasPollingRequested event,
    Emitter<GuiasState> emit,
  ) {
    _currentProgramacionId = event.idProgramacion;
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(AppConstants.pollingInterval, (_) {
      if (_currentProgramacionId != null) {
        add(FetchGuiasRequested(
          idProgramacion: _currentProgramacionId!,
          isSilentRefresh: true,
        ));
      }
    });

    if (state is GuiasLoaded) {
      emit((state as GuiasLoaded).copyWith(isPollingActive: true));
    }
  }

  void _onStopPolling(
    StopGuiasPollingRequested event,
    Emitter<GuiasState> emit,
  ) {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    if (state is GuiasLoaded) {
      emit((state as GuiasLoaded).copyWith(isPollingActive: false));
    }
  }

  Future<void> _onDownloadPdf(
    DownloadGuiaPdfRequested event,
    Emitter<GuiasState> emit,
  ) async {
    if (state is! GuiasLoaded) return;
    final currentState = state as GuiasLoaded;

    emit(currentState.copyWith(downloadingGuiaId: event.idGuia));

    try {
      if (event.directUrl != null &&
          event.directUrl!.isNotEmpty &&
          event.directUrl!.startsWith('http')) {
        final uri = Uri.parse(event.directUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          emit(currentState.copyWith(clearDownloading: true));
          return;
        }
      }

      final filePath = await downloadPdfUseCase(
        idGuia: event.idGuia,
        numeroGuia: event.numeroGuia,
      );

      // Open PDF file with OpenFilex
      await OpenFilex.open(filePath);

      emit(currentState.copyWith(
        downloadedPdfPath: filePath,
        clearDownloading: true,
      ));
    } catch (e) {
      emit(currentState.copyWith(clearDownloading: true));
    }
  }

  Future<void> _onFetchSunatMensaje(
    FetchSunatMensajeRequested event,
    Emitter<GuiasState> emit,
  ) async {
    if (state is! GuiasLoaded) return;
    final currentState = state as GuiasLoaded;

    try {
      final mensaje = await getSunatMensajeUseCase(idGuia: event.idGuia);
      emit(currentState.copyWith(activeSunatMensaje: mensaje));
    } catch (_) {
      emit(currentState.copyWith(
        activeSunatMensaje: null,
      ));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    return super.close();
  }
}
