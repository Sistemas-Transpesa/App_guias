import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../domain/entities/config_entity.dart';
import '../cubit/guia_create_cubit.dart';
import '../cubit/guia_create_state.dart';
import '../widgets/add_documento_relacionado_dialog.dart';
import '../widgets/series_remitentes_list.dart';

class GuiaCreateBottomSheet extends StatelessWidget {
  final String idProgramacion;
  final String? idCliente;
  final bool initialIsTicketMode;
  final VoidCallback onGuiaCreated;

  const GuiaCreateBottomSheet({
    super.key,
    required this.idProgramacion,
    this.idCliente,
    required this.initialIsTicketMode,
    required this.onGuiaCreated,
  });

  static Future<void> show(
    BuildContext context, {
    required String idProgramacion,
    String? idCliente,
    required bool initialIsTicketMode,
    required VoidCallback onGuiaCreated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider(
        create: (context) => sl<GuiaCreateCubit>()
          ..loadConfig(
            idProgramacion: idProgramacion,
            idCliente: idCliente,
            isTicketMode: initialIsTicketMode,
          ),
        child: GuiaCreateBottomSheet(
          idProgramacion: idProgramacion,
          idCliente: idCliente,
          initialIsTicketMode: initialIsTicketMode,
          onGuiaCreated: onGuiaCreated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuiaCreateCubit, GuiaCreateState>(
      listener: (context, state) {
        if (state is GuiaCreateSuccess) {
          CustomSnackbar.showSuccess(
            context,
            'Guía ${state.guia.numeroCompleto} emitida con éxito',
          );
          onGuiaCreated();
          Navigator.of(context).pop();
        } else if (state is GuiaCreateFormState && state.errorMessage != null) {
          CustomSnackbar.showError(context, state.errorMessage!);
        } else if (state is GuiaCreateError) {
          CustomSnackbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GuiaCreateLoadingConfig) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitCubeGrid(color: AppColors.primary, size: 40.0),
                  SizedBox(height: 16),
                  Text(
                    'Cargando configuración de remitentes...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GuiaCreateError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.sunatRechazado,
                ),
                const SizedBox(height: 12),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<GuiaCreateCubit>().loadConfig(
                          idProgramacion: idProgramacion,
                          idCliente: idCliente,
                          isTicketMode: initialIsTicketMode,
                        );
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is GuiaCreateFormState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.note_add_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emitir Guía de Transportista',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Formulario en cascada con SUNAT',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Level 1: Remitente
                    const _SectionHeader(
                      number: '1',
                      title: 'Remitente (Empresa origen)',
                    ),
                    const SizedBox(height: 6),
                    _buildDropdown<RemitenteConfigEntity>(
                      label: 'Seleccione Remitente',
                      items: state.remitentes,
                      value: state.selectedRemitente,
                      itemText: (r) => '${r.razonSocial} (${r.ruc})',
                      onChanged: (val) {
                        if (val != null) {
                          context.read<GuiaCreateCubit>().onRemitenteSelected(val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Level 2: Destinatario
                    const _SectionHeader(
                      number: '2',
                      title: 'Destinatario (Empresa destino)',
                    ),
                    const SizedBox(height: 6),
                    _buildDropdown<DestinatarioConfigEntity>(
                      label: 'Seleccione Destinatario',
                      items: state.destinatarios,
                      value: state.selectedDestinatario,
                      itemText: (d) => '${d.razonSocial} (${d.ruc})',
                      onChanged: (val) {
                        if (val != null) {
                          context.read<GuiaCreateCubit>().onDestinatarioSelected(val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Level 3: Dirección de Partida
                    const _SectionHeader(
                      number: '3',
                      title: 'Punto de Partida',
                    ),
                    const SizedBox(height: 6),
                    _buildDropdown<DireccionPartidaConfigEntity>(
                      label: 'Seleccione Dirección de Partida',
                      items: state.direccionesPartida,
                      value: state.selectedDireccionPartida,
                      itemText: (p) => '${p.direccion} [Ubigeo: ${p.ubigeo}]',
                      onChanged: (val) {
                        if (val != null) {
                          context.read<GuiaCreateCubit>().onDireccionPartidaSelected(val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Level 4: Dirección de Destino / Llegada
                    const _SectionHeader(
                      number: '4',
                      title: 'Punto de Llegada (Destino)',
                    ),
                    const SizedBox(height: 6),
                    _buildDropdown<DireccionDestinoConfigEntity>(
                      label: 'Seleccione Dirección de Destino',
                      items: state.direccionesDestino,
                      value: state.selectedDireccionDestino,
                      itemText: (d) => '${d.direccion} [Ubigeo: ${d.ubigeo}]',
                      onChanged: (val) {
                        if (val != null) {
                          context.read<GuiaCreateCubit>().onDireccionDestinoSelected(val);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Modalidad Switch: Tickets vs Guías Remitentes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tipo de Documentos',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              state.isTicketMode
                                  ? 'Modalidad: Tickets de Balanza'
                                  : 'Modalidad: Guías de Remitente',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: state.isTicketMode,
                          activeThumbColor: AppColors.secondaryDark,
                          activeTrackColor: AppColors.secondary.withOpacity(0.4),
                          onChanged: (val) {
                            context.read<GuiaCreateCubit>().setTicketMode(val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Series / Tickets List Header & Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.isTicketMode
                              ? 'Tickets Agregados (${state.documentosRelacionados.length})'
                              : 'Guías Remitentes (${state.documentosRelacionados.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            minimumSize: const Size(110, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            AddDocumentoRelacionadoDialog.show(
                              context,
                              isTicketMode: state.isTicketMode,
                              onAdd: ({required serie, required numero, required pesoKg}) {
                                context.read<GuiaCreateCubit>().addDocumentoRelacionado(
                                      serie: serie,
                                      numero: numero,
                                      pesoKg: pesoKg,
                                    );
                              },
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text(
                            'Agregar',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // List of Added Series/Tickets
                    SeriesRemitentesList(
                      items: state.documentosRelacionados,
                      onDelete: (id) {
                        context.read<GuiaCreateCubit>().removeDocumentoRelacionado(id);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Total Summed Weight Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Peso Bruto Total Acumulado:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${state.pesoTotalKg.toStringAsFixed(4)} KG',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Observaciones
                    TextFormField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones (Opcional)',
                        hintText: 'Ingrese alguna nota adicional para el viaje...',
                      ),
                      onChanged: (val) {
                        context.read<GuiaCreateCubit>().setObservacion(val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isValid
                            ? AppColors.primary
                            : AppColors.textMuted.withOpacity(0.5),
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              context.read<GuiaCreateCubit>().submit(
                                    idProgramacion: idProgramacion,
                                  );
                            },
                      child: state.isSubmitting
                          ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'EMITIR GUÍA A SUNAT',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? value,
    required String Function(T item) itemText,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemText(item),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String number;
  final String title;

  const _SectionHeader({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
