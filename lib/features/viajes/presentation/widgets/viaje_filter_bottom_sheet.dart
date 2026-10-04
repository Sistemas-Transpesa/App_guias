import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';

class ViajeFilterBottomSheet extends StatefulWidget {
  final DateTime? initialFechaInicio;
  final DateTime? initialFechaFin;
  final Function(DateTime fechaInicio, DateTime fechaFin) onApply;
  final VoidCallback onReset;

  const ViajeFilterBottomSheet({
    super.key,
    this.initialFechaInicio,
    this.initialFechaFin,
    required this.onApply,
    required this.onReset,
  });

  static Future<void> show(
    BuildContext context, {
    DateTime? initialFechaInicio,
    DateTime? initialFechaFin,
    required Function(DateTime fechaInicio, DateTime fechaFin) onApply,
    required VoidCallback onReset,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ViajeFilterBottomSheet(
        initialFechaInicio: initialFechaInicio,
        initialFechaFin: initialFechaFin,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<ViajeFilterBottomSheet> createState() => _ViajeFilterBottomSheetState();
}

class _ViajeFilterBottomSheetState extends State<ViajeFilterBottomSheet> {
  late DateTime _fechaInicio;
  late DateTime _fechaFin;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fechaInicio = widget.initialFechaInicio ?? now;
    _fechaFin = widget.initialFechaFin ?? now;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _fechaInicio : _fechaFin;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _fechaInicio = picked;
          if (_fechaInicio.isAfter(_fechaFin)) {
            _fechaFin = picked;
          }
        } else {
          _fechaFin = picked;
          if (_fechaFin.isBefore(_fechaInicio)) {
            _fechaInicio = picked;
          }
        }
      });
    }
  }

  void _setQuickRange(int days) {
    final now = DateTime.now();
    setState(() {
      _fechaFin = now;
      _fechaInicio = now.subtract(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list_rounded,
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
                      'Filtrar Viajes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text(
                      'Seleccione un rango de fechas',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
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

          // Quick Filter Chips
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('Hoy'),
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                onPressed: () => _setQuickRange(0),
              ),
              ActionChip(
                label: const Text('Últimos 7 días'),
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                onPressed: () => _setQuickRange(7),
              ),
              ActionChip(
                label: const Text('Últimos 30 días'),
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                onPressed: () => _setQuickRange(30),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Selectors
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  title: 'Fecha Desde',
                  date: _fechaInicio,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  title: 'Fecha Hasta',
                  date: _fechaFin,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_fechaInicio, _fechaFin);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aplicar Filtro'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormatter.toDisplayDate(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
