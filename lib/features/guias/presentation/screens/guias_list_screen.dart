import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../viajes/domain/entities/viaje_entity.dart';
import '../bloc/guias_bloc.dart';
import '../bloc/guias_event.dart';
import '../bloc/guias_state.dart';
import '../widgets/guia_card.dart';
import '../widgets/sunat_mensaje_dialog.dart';
import 'guia_create_bottom_sheet.dart';

class GuiasListScreen extends StatelessWidget {
  final ViajeEntity viaje;

  const GuiasListScreen({super.key, required this.viaje});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GuiasBloc>()
        ..add(FetchGuiasRequested(idProgramacion: viaje.idProgramacion))
        ..add(StartGuiasPollingRequested(idProgramacion: viaje.idProgramacion)),
      child: _GuiasListView(viaje: viaje),
    );
  }
}

class _GuiasListView extends StatefulWidget {
  final ViajeEntity viaje;

  const _GuiasListView({required this.viaje});

  @override
  State<_GuiasListView> createState() => _GuiasListViewState();
}

class _GuiasListViewState extends State<_GuiasListView> {
  @override
  void dispose() {
    // Polling will be stopped in GuiasBloc.close() automatically
    super.dispose();
  }

  void _openCreateGuiaModal(BuildContext context) {
    GuiaCreateBottomSheet.show(
      context,
      idProgramacion: widget.viaje.idProgramacion,
      idCliente: widget.viaje.rucCliente,
      initialIsTicketMode: widget.viaje.isTicketType,
      onGuiaCreated: () {
        context.read<GuiasBloc>().add(
              FetchGuiasRequested(
                idProgramacion: widget.viaje.idProgramacion,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guías - ${widget.viaje.codViaje.isNotEmpty ? widget.viaje.codViaje : widget.viaje.idProgramacion}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.viaje.cliente,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar guías',
            onPressed: () {
              context.read<GuiasBloc>().add(
                    FetchGuiasRequested(
                      idProgramacion: widget.viaje.idProgramacion,
                    ),
                  );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nueva Guía',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        onPressed: () => _openCreateGuiaModal(context),
      ),
      body: BlocConsumer<GuiasBloc, GuiasState>(
        listener: (context, state) {
          if (state is GuiasLoaded && state.activeSunatMensaje != null) {
            // Find active guia
            final guia = state.guias.firstWhere(
              (g) => g.id == state.activeSunatMensaje!.idGuia,
              orElse: () => state.guias.first,
            );
            SunatMensajeDialog.show(
              context,
              guia: guia,
              sunatMensaje: state.activeSunatMensaje,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Trip Context Header Banner
              _buildTripBanner(context),

              // Main Content
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTripBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.route_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.viaje.ruta,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.viaje.isTicketType)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BALANZA',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Tracto: ${widget.viaje.tracto}  •  Carreta: ${widget.viaje.carreta}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.sync_rounded,
                size: 12,
                color: AppColors.sunatAceptado,
              ),
              const SizedBox(width: 4),
              const Text(
                'Auto-polling 2m',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, GuiasState state) {
    if (state is GuiasLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCubeGrid(color: AppColors.primary, size: 40.0),
            SizedBox(height: 16),
            Text(
              'Consultando estado de guías en SUNAT...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (state is GuiasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.sunatRechazado,
              ),
              const SizedBox(height: 14),
              const Text(
                'Error al consultar las guías',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GuiasBloc>().add(
                        FetchGuiasRequested(
                          idProgramacion: widget.viaje.idProgramacion,
                        ),
                      );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is GuiasLoaded) {
      if (state.guias.isEmpty) {
        return _buildEmptyGuias(context);
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<GuiasBloc>().add(
                FetchGuiasRequested(
                  idProgramacion: widget.viaje.idProgramacion,
                ),
              );
        },
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 80),
          itemCount: state.guias.length,
          itemBuilder: (context, index) {
            final guia = state.guias[index];
            final isDownloading = state.downloadingGuiaId == guia.id;

            return GuiaCard(
              guia: guia,
              isDownloading: isDownloading,
              onDownloadPdf: () {
                context.read<GuiasBloc>().add(
                      DownloadGuiaPdfRequested(
                        idGuia: guia.id,
                        numeroGuia: guia.numeroCompleto,
                        directUrl: guia.pdfUrl,
                      ),
                    );
              },
              onSunatTap: () {
                if (guia.isRechazado ||
                    guia.isPendiente ||
                    (guia.mensajeSunat != null &&
                        guia.mensajeSunat!.isNotEmpty)) {
                  context.read<GuiasBloc>().add(
                        FetchSunatMensajeRequested(idGuia: guia.id),
                      );
                } else {
                  SunatMensajeDialog.show(context, guia: guia);
                }
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyGuias(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 56,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay guías emitidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este viaje aún no cuenta con guías transportista registradas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _openCreateGuiaModal(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Emitir Primera Guía'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
