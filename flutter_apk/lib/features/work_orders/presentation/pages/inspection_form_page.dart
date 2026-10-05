import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/inspection.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_bloc.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_event.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_state.dart';

class InspectionFormPage extends StatefulWidget {
  const InspectionFormPage({super.key, required this.workOrder});

  final WorkOrder workOrder;

  @override
  State<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends State<InspectionFormPage> {
  final TextEditingController _observationController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedCondition;
  XFile? _selectedPhoto;
  Position? _position;
  bool _isLoadingLocation = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  Position _fallbackPosition({double? latitude, double? longitude}) {
    return Position(
      latitude: latitude ?? widget.workOrder.latitude,
      longitude: longitude ?? widget.workOrder.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      floor: null,
      isMocked: false,
    );
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _position = _fallbackPosition();
      } else {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _position = _fallbackPosition();
        } else {
          _position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 15),
            ),
          );
        }
      }
    } catch (_) {
      _position = _fallbackPosition();
    }

    if (mounted) {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedPhoto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (pickedPhoto == null) {
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final extension = p.extension(pickedPhoto.path);
      final storedPhoto = await File(pickedPhoto.path).copy(
        p.join(
          directory.path,
          'inspection_${DateTime.now().microsecondsSinceEpoch}$extension',
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() => _selectedPhoto = XFile(storedPhoto.path));
    } catch (error) {
      _showMessage('Não foi possível capturar a foto: $error');
    }
  }

  String _generateClientId() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }

  Future<void> _submitInspection({required bool asDraft}) async {
    final observation = _observationController.text.trim();
    if (observation.length < 10) {
      _showMessage('A observação deve ter pelo menos 10 caracteres.');
      return;
    }

    if (!asDraft && _selectedPhoto == null) {
      _showMessage('Capture uma foto para concluir a inspeção.');
      return;
    }

    setState(() => _isSubmitting = true);

    final clientId = _generateClientId();
    final safePosition = _position ?? _fallbackPosition();
    final now = DateTime.now().toUtc();

    final inspection = Inspection(
      id: clientId,
      clientId: clientId,
      workOrderId: widget.workOrder.id,
      observation: observation,
      condition: _selectedCondition,
      latitude: safePosition.latitude,
      longitude: safePosition.longitude,
      capturedAt: now,
      createdAt: now,
      photoPath: _selectedPhoto?.path,
      status: asDraft ? Inspection.statusDraft : Inspection.statusPending,
    );

    final bloc = context.read<InspectionBloc>();
    bloc.add(
      asDraft
          ? SaveDraftInspectionEvent(inspection)
          : SavePendingInspectionEvent(inspection),
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final location = _position ?? _fallbackPosition();

    return BlocListener<InspectionBloc, InspectionState>(
      listener: (context, state) {
        if (!_isSubmitting) {
          return;
        }
        if (state is InspectionErrorState) {
          setState(() => _isSubmitting = false);
          _showMessage(state.message);
        } else if (state is InspectionActionCompletedState) {
          Navigator.of(context).pop(
            state.message == 'draft'
                ? 'Rascunho salvo com sucesso.'
                : 'Inspeção salva na fila de sincronização.',
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          title: const Text('Nova inspeção'),
          backgroundColor: AppColors.bgLight,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workOrder.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.workOrder.address,
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Observação',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _observationController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Descreva o que foi observado...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Condição',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCondition,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'bom', child: Text('Bom')),
                    DropdownMenuItem(value: 'regular', child: Text('Regular')),
                    DropdownMenuItem(value: 'ruim', child: Text('Ruim')),
                    DropdownMenuItem(value: 'crítico', child: Text('Crítico')),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedCondition = value),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Localização',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _isLoadingLocation
                      ? const Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Capturando GPS...'),
                          ],
                        )
                      : Text(
                          'Lat: ${location.latitude.toStringAsFixed(5)}\nLong: ${location.longitude.toStringAsFixed(5)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.darkText,
                            height: 1.6,
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Evidência fotográfica',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                if (_selectedPhoto != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(_selectedPhoto!.path),
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'Nenhuma foto capturada.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Capturar foto'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _submitInspection(asDraft: true),
                        child: const Text('Salvar rascunho'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _submitInspection(asDraft: false),
                        child: Text(_isSubmitting ? 'Enviando...' : 'Concluir'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
