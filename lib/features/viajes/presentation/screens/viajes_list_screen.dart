import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/viajes_bloc.dart';
import '../bloc/viajes_event.dart';
import '../bloc/viajes_state.dart';
import '../widgets/viaje_card.dart';
import '../widgets/viaje_detail_bottom_sheet.dart';
import '../widgets/viaje_filter_bottom_sheet.dart';

class ViajesListScreen extends StatelessWidget {
  const ViajesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ViajesBloc>()..add(const FetchViajesRequested()),
      child: const _ViajesListView(),
    );
  }
}

class _ViajesListView extends StatelessWidget {
  const _ViajesListView();

  void _showFilterModal(BuildContext context, ViajesLoaded? loadedState) {
    ViajeFilterBottomSheet.show(
      context,
      initialFechaInicio: loadedState?.fechaInicio,
      initialFechaFin: loadedState?.fechaFin,
      onApply: (inicio, fin) {
        context.read<ViajesBloc>().add(
              FilterViajesByDateRequested(
                fechaInicio: inicio,
                fechaFin: fin,
              ),
            );
      },
      onReset: () {
        context.read<ViajesBloc>().add(ResetViajesFilterRequested());
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.sunatRechazado),
            SizedBox(width: 10),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text(
          '¿Está seguro de que desea cerrar la sesión actual?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sunatRechazado,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final userName = authState is Authenticated
                ? authState.user.nombre
                : 'Conductor';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Viajes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          BlocBuilder<ViajesBloc, ViajesState>(
            builder: (context, state) {
              final loaded = state is ViajesLoaded ? state : null;
              final hasFilter = loaded?.hasActiveFilter ?? false;

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    tooltip: 'Filtrar por fecha',
                    onPressed: () => _showFilterModal(context, loaded),
                  ),
                  if (hasFilter)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ViajesBloc, ViajesState>(
        builder: (context, state) {
          if (state is ViajesLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: AppColors.primary,
                    size: 40.0,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando programaciones...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ViajesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.sunatRechazadoBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.sunatRechazado,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudieron cargar los viajes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<ViajesBloc>()
                            .add(const FetchViajesRequested());
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 44),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ViajesLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<ViajesBloc>().add(
                      FetchViajesRequested(
                        fechaInicio: state.fechaInicio != null
                            ? DateFormatter.toApiDate(state.fechaInicio)
                            : null,
                        fechaFin: state.fechaFin != null
                            ? DateFormatter.toApiDate(state.fechaFin)
                            : null,
                        isRefresh: true,
                      ),
                    );
              },
              child: Column(
                children: [
                  // Active Filter Banner
                  if (state.hasActiveFilter)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: AppColors.primaryLight.withOpacity(0.08),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_alt_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Filtro: ${DateFormatter.toDisplayDate(state.fechaInicio)} - ${DateFormatter.toDisplayDate(state.fechaFin)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context
                                  .read<ViajesBloc>()
                                  .add(ResetViajesFilterRequested());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                'Quitar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.sunatRechazado,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // List of Trips or Empty State
                  Expanded(
                    child: state.viajes.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 4,
                            ),
                            itemCount: state.viajes.length,
                            itemBuilder: (context, index) {
                              final viaje = state.viajes[index];
                              return ViajeCard(
                                viaje: viaje,
                                onTap: () {
                                  context.push(
                                    '/viajes/${viaje.idProgramacion}/guias',
                                    extra: viaje,
                                  );
                                },
                                onInfoTap: () {
                                  ViajeDetailBottomSheet.show(context, viaje);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                Icons.alt_route_rounded,
                size: 56,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay viajes programados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No se encontraron programaciones para la fecha o criterios seleccionados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<ViajesBloc>()
                    .add(const FetchViajesRequested(isRefresh: true));
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Actualizar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(140, 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
