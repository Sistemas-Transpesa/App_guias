import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/viaje_entity.dart';

class ViajeDetailBottomSheet extends StatelessWidget {
  final ViajeEntity viaje;

  const ViajeDetailBottomSheet({
    super.key,
    required this.viaje,
  });

  static Future<void> show(BuildContext context, ViajeEntity viaje) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ViajeDetailBottomSheet(viaje: viaje),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle is rendered by bottomSheetTheme, now header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalle del Viaje',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Código: ${viaje.codViaje.isNotEmpty ? viaje.codViaje : viaje.idProgramacion}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Sections
          _buildInfoTile(
            icon: Icons.business_rounded,
            title: 'Cliente / Empresa',
            value: viaje.cliente,
            secondaryValue: viaje.rucCliente != null && viaje.rucCliente!.isNotEmpty
                ? 'RUC: ${viaje.rucCliente}'
                : null,
          ),
          const SizedBox(height: 14),

          _buildInfoTile(
            icon: Icons.person_rounded,
            title: 'Conductor Asignado',
            value: viaje.conductor,
            secondaryValue: viaje.dniConductor != null && viaje.dniConductor!.isNotEmpty
                ? 'DNI: ${viaje.dniConductor}'
                : null,
          ),
          const SizedBox(height: 14),

          _buildInfoTile(
            icon: Icons.alt_route_rounded,
            title: 'Ruta de Transporte',
            value: viaje.ruta,
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Placa Tracto',
                  value: viaje.tracto,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.rv_hookup_outlined,
                  title: 'Placa Carreta',
                  value: viaje.carreta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'Fecha Programada',
                  value: DateFormatter.formatStringDate(viaje.fecha),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.scale_rounded,
                  title: 'Modalidad de Viaje',
                  value: viaje.isTicketType ? 'Ticket / Balanza' : 'Guía Estándar',
                ),
              ),
            ],
          ),

          if (viaje.observacion != null && viaje.observacion!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildInfoTile(
              icon: Icons.notes_rounded,
              title: 'Observación',
              value: viaje.observacion!,
            ),
          ],
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ENTENDIDO'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    String? secondaryValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (secondaryValue != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    secondaryValue,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
