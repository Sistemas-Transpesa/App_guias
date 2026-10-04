import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guia_entity.dart';
import '../../domain/entities/sunat_mensaje_entity.dart';

class SunatMensajeDialog extends StatelessWidget {
  final GuiaEntity guia;
  final SunatMensajeEntity? sunatMensaje;

  const SunatMensajeDialog({
    super.key,
    required this.guia,
    this.sunatMensaje,
  });

  static Future<void> show(
    BuildContext context, {
    required GuiaEntity guia,
    SunatMensajeEntity? sunatMensaje,
  }) {
    return showDialog(
      context: context,
      builder: (_) => SunatMensajeDialog(
        guia: guia,
        sunatMensaje: sunatMensaje,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRejected = guia.isRechazado;
    final isAccepted = guia.isAceptado;

    final headerColor = isAccepted
        ? AppColors.sunatAceptado
        : (isRejected ? AppColors.sunatRechazado : AppColors.sunatAlerta);

    final headerIcon = isAccepted
        ? Icons.check_circle_outline_rounded
        : (isRejected ? Icons.error_outline_rounded : Icons.info_outline_rounded);

    final title = isAccepted
        ? 'Guía Aceptada por SUNAT'
        : (isRejected ? 'Guía Rechazada / Observada' : 'Estado SUNAT en Proceso');

    final messageContent = sunatMensaje?.mensaje ??
        guia.mensajeSunat ??
        (isAccepted
            ? 'El comprobante ha sido aceptado satisfactoriamente por la SUNAT.'
            : 'El comprobante se encuentra en validación.');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: headerColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(headerIcon, color: headerColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guía de Remisión: ${guia.numeroCompleto}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (sunatMensaje?.codigo != null &&
                      sunatMensaje!.codigo.isNotEmpty &&
                      sunatMensaje!.codigo != '0') ...[
                    const SizedBox(height: 4),
                    Text(
                      'Código de Respuesta SUNAT: ${sunatMensaje!.codigo}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Detalle de la Respuesta:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRejected ? AppColors.sunatRechazadoBg : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isRejected
                      ? AppColors.sunatRechazado.withOpacity(0.3)
                      : AppColors.border,
                ),
              ),
              child: Text(
                messageContent,
                style: TextStyle(
                  fontSize: 13,
                  color: isRejected ? AppColors.sunatRechazado : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            if (sunatMensaje?.observacion != null &&
                sunatMensaje!.observacion!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Observaciones Adicionales:\n${sunatMensaje!.observacion}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(100, 42),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
