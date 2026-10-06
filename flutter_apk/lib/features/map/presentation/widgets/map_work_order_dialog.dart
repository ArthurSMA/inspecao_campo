import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class MapWorkOrderDialog extends StatefulWidget {
  const MapWorkOrderDialog({super.key, required this.location});

  final LatLng location;

  static Future<({String title, String? notes, String priority})?> show(
    BuildContext context,
    LatLng location,
  ) {
    return showDialog<({String title, String? notes, String priority})>(
      context: context,
      builder: (_) => MapWorkOrderDialog(location: location),
    );
  }

  @override
  State<MapWorkOrderDialog> createState() => _MapWorkOrderDialogState();
}

class _MapWorkOrderDialogState extends State<MapWorkOrderDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _priority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final notes = _notesController.text.trim();
    Navigator.pop(context, (
      title: title,
      notes: notes.isEmpty ? null : notes,
      priority: _priority,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova ordem de serviço'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridade'),
              items: const [
                DropdownMenuItem(value: 'high', child: Text('Alta')),
                DropdownMenuItem(value: 'medium', child: Text('Média')),
                DropdownMenuItem(value: 'low', child: Text('Baixa')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),
            TextField(
              controller: _notesController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.location.latitude.toStringAsFixed(6)}, '
              '${widget.location.longitude.toStringAsFixed(6)}',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}
