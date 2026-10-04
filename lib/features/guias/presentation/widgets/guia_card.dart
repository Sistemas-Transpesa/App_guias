import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/guia_entity.dart';
import 'sunat_badge.dart';

class GuiaCard extends StatelessWidget {
  final GuiaEntity guia;
  final bool isDownloading;
  final VoidCallback onDownloadPdf;
  final VoidCallback onSunatTap;

  const GuiaCard({
    super.key,
    required this.guia,
    this.isDownloading = false,
    required this.onDownloadPdf,
    required this.onSunatTap,
  });

  @override
  Widget build(BuildContext context) {
    final canDownloadPdf = guia.isAceptado || (guia.pdfUrl != null && guia.pdfUrl!.isNotEmpty);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Number, SUNAT Status, Info Button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.description_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        guia.numeroCompleto,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onSunatTap,
                  borderRadius: BorderRadius.circular(8),
                  child: SunatBadge(guia: guia),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Remitente & Destinatario
            if (guia.remitenteRazonSocial != null &&
                guia.remitenteRazonSocial!.isNotEmpty) ...[
              _buildParticipantRow(
                icon: Icons.send_rounded,
                role: 'Remitente',
                name: guia.remitenteRazonSocial!,
                ruc: guia.remitenteRuc,
              ),
              const SizedBox(height: 8),
            ],

            if (guia.destinatarioRazonSocial != null &&
                guia.destinatarioRazonSocial!.isNotEmpty) ...[
              _buildParticipantRow(
                icon: Icons.call_received_rounded,
                role: 'Destinatario',
                name: guia.destinatarioRazonSocial!,
                ruc: guia.destinatarioRuc,
              ),
              const SizedBox(height: 8),
            ],

            // Addresses
            if (guia.direccionPartida != null &&
                guia.direccionPartida!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Partida: ${guia.direccionPartida} ${guia.ubigeoPartida != null ? "(${guia.ubigeoPartida})" : ""}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            if (guia.direccionDestino != null &&
                guia.direccionDestino!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.flag_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Llegada: ${guia.direccionDestino} ${guia.ubigeoDestino != null ? "(${guia.ubigeoDestino})" : ""}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            const Divider(height: 1),
            const SizedBox(height: 10),

            // Footer: Weight & Emisión & Actions
            Row(
              children: [
                // Peso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Peso Bruto Total',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${guia.pesoBrutoTotal.toStringAsFixed(2)} ${guia.unidadMedida}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Fecha Emisión
                if (guia.fechaEmision != null) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emisión',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormatter.formatStringDate(guia.fechaEmision),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],

                const Spacer(),

                // SUNAT Message button (if rejected or message exists)
                if (guia.isRechazado || (guia.mensajeSunat != null && guia.mensajeSunat!.isNotEmpty))
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.sunatRechazado,
                      size: 22,
                    ),
                    tooltip: 'Ver observación SUNAT',
                    onPressed: onSunatTap,
                  ),

                // Download/Open PDF Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canDownloadPdf
                        ? AppColors.primary
                        : AppColors.textMuted.withOpacity(0.3),
                    foregroundColor: canDownloadPdf ? Colors.white : AppColors.textSecondary,
                    elevation: 0,
                    minimumSize: const Size(105, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (canDownloadPdf && !isDownloading) ? onDownloadPdf : null,
                  icon: isDownloading
                      ? const SpinKitThreeBounce(color: Colors.white, size: 14)
                      : const Icon(Icons.picture_as_pdf_rounded, size: 16),
                  label: Text(
                    isDownloading ? 'Abriendo' : 'Ver PDF',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantRow({
    required IconData icon,
    required String role,
    required String name,
    String? ruc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primaryLight),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              children: [
                TextSpan(
                  text: '$role: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (ruc != null && ruc.isNotEmpty)
                  TextSpan(
                    text: ' ($ruc)',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
