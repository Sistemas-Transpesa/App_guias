import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guia_entity.dart';

class SunatBadge extends StatelessWidget {
  final GuiaEntity guia;

  const SunatBadge({super.key, required this.guia});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    IconData icon;
    String label;

    if (guia.isAceptado) {
      bg = AppColors.sunatAceptadoBg;
      text = AppColors.sunatAceptado;
      icon = Icons.check_circle_rounded;
      label = 'ACEPTADO';
    } else if (guia.isRechazado) {
      bg = AppColors.sunatRechazadoBg;
      text = AppColors.sunatRechazado;
      icon = Icons.cancel_rounded;
      label = 'RECHAZADO';
    } else {
      bg = AppColors.sunatPendienteBg;
      text = AppColors.sunatPendiente;
      icon = Icons.schedule_rounded;
      label = 'PENDIENTE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: text.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
