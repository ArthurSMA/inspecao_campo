import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspecao_campo/core/utils/colors.dart';
import 'package:inspecao_campo/core/utils/geo_utils.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/inspection_bloc.dart';
import 'package:inspecao_campo/features/work_orders/presentation/pages/inspection_form_page.dart';

class WorkOrderCard extends StatefulWidget {
  const WorkOrderCard({super.key, required this.order});

  final WorkOrder order;

  @override
  State<WorkOrderCard> createState() => _WorkOrderCardState();
}

class _WorkOrderCardState extends State<WorkOrderCard> {
  Future<void> _handleStartInspection() async {
    final inspectionBloc = context.read<InspectionBloc>();
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => BlocProvider.value(
          value: inspectionBloc,
          child: InspectionFormPage(workOrder: widget.order),
        ),
      ),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'EM ANDAMENTO';
      case 'done':
        return 'CONCLUÍDA';
      case 'open':
      default:
        return 'ABERTA';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return AppColors.warning;
      case 'done':
        return AppColors.success;
      case 'open':
      default:
        return AppColors.info;
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'in_progress':
        return AppColors.warningSoft;
      case 'done':
        return AppColors.successSoft;
      case 'open':
      default:
        return AppColors.infoSoft;
    }
  }

  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'ALTA';
      case 'medium':
        return 'MÉDIA';
      case 'low':
      default:
        return 'BAIXA';
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      case 'low':
      default:
        return AppColors.success;
    }
  }

  Color _priorityBackground(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.dangerSoft;
      case 'medium':
        return AppColors.warningSoft;
      case 'low':
      default:
        return AppColors.successSoft;
    }
  }

  String _actionLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'Continuar Inspeção';
      case 'done':
        return 'Ver Resumo';
      case 'open':
      default:
        return 'Iniciar Inspeção';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(widget.order.status);
    final statusBackground = _statusBackground(widget.order.status);
    final priorityColor = _priorityColor(widget.order.priority);
    final priorityBackground = _priorityBackground(widget.order.priority);
    final coordinateSummary = GeoUtils.formatCoordinate(
      widget.order.latitude,
      widget.order.longitude,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusLabel(widget.order.status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: priorityBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'PRIORIDADE ${_priorityLabel(widget.order.priority)}',
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${widget.order.code} • ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: widget.order.title,
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.order.description,
            style: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.location_on_rounded,
                  label: 'Endereço',
                  value: widget.order.address,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoRow(
                        icon: Icons.my_location_rounded,
                        label: 'Latitude',
                        value: widget.order.latitude.toStringAsFixed(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoRow(
                        icon: Icons.gps_fixed_rounded,
                        label: 'Longitude',
                        value: widget.order.longitude.toStringAsFixed(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.gps_fixed_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'GPS: $coordinateSummary',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkText,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: _handleStartInspection,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_actionLabel(widget.order.status)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
