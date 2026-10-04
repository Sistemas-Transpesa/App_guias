import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

class AddDocumentoRelacionadoDialog extends StatefulWidget {
  final bool isTicketMode;
  final Function({
    required String serie,
    required String numero,
    required double pesoKg,
  }) onAdd;

  const AddDocumentoRelacionadoDialog({
    super.key,
    required this.isTicketMode,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isTicketMode,
    required Function({
      required String serie,
      required String numero,
      required double pesoKg,
    }) onAdd,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AddDocumentoRelacionadoDialog(
        isTicketMode: isTicketMode,
        onAdd: onAdd,
      ),
    );
  }

  @override
  State<AddDocumentoRelacionadoDialog> createState() =>
      _AddDocumentoRelacionadoDialogState();
}

class _AddDocumentoRelacionadoDialogState
    extends State<AddDocumentoRelacionadoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _serieController = TextEditingController();
  final _numeroController = TextEditingController();
  final _pesoController = TextEditingController();

  @override
  void dispose() {
    _serieController.dispose();
    _numeroController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final serie = _serieController.text.trim().toUpperCase();
      final numero = _numeroController.text.trim();
      final peso = double.parse(_pesoController.text.trim().replaceAll(',', '.'));

      widget.onAdd(
        serie: serie,
        numero: numero,
        pesoKg: peso,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final docTypeName = widget.isTicketMode ? 'Ticket de Balanza' : 'Guía Remitente';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.isTicketMode ? Icons.scale_rounded : Icons.description_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Agregar $docTypeName',
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: _serieController,
                      textCapitalization: TextCapitalization.characters,
                      validator: Validators.validateSerie,
                      decoration: const InputDecoration(
                        labelText: 'Serie',
                        hintText: 'Ej. T001',
                        prefixIcon: Icon(Icons.pin_rounded, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: _numeroController,
                      keyboardType: TextInputType.number,
                      validator: Validators.validateNumero,
                      decoration: const InputDecoration(
                        labelText: 'Número',
                        hintText: 'Ej. 0001234',
                        prefixIcon: Icon(Icons.tag_rounded, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pesoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.\,]?\d{0,4}')),
                ],
                validator: Validators.validateWeight,
                decoration: const InputDecoration(
                  labelText: 'Peso Total (KG)',
                  hintText: 'Ej. 25000.5000',
                  prefixIcon: Icon(Icons.fitness_center_rounded, size: 18),
                  suffixText: 'KG',
                  helperText: 'Hasta 4 decimales permitidos',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(110, 42),
          ),
          onPressed: _onSave,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
