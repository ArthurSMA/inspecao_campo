import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/inspection.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_bloc.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_event.dart';
import 'package:inpecao_campo/features/work_orders/presentation/bloc/inspection_state.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  late final InspectionBloc _inspectionBloc;
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _inspectionBloc = context.read<InspectionBloc>()
      ..add(LoadInspectionHistoryEvent());
  }

  void _filterInspections(String status) {
    setState(() => _selectedStatus = status);
    _inspectionBloc.add(FilterInspectionHistoryEvent(status));
  }

  String _statusLabel(String status) {
    switch (status) {
      case Inspection.statusDraft:
        return 'Rascunho';
      case Inspection.statusPending:
        return 'Aguardando envio';
      case Inspection.statusSynced:
        return 'Sincronizada';
      case Inspection.statusFailed:
        return 'Falha no envio';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case Inspection.statusSynced:
        return AppColors.success;
      case Inspection.statusFailed:
        return AppColors.danger;
      case Inspection.statusPending:
        return AppColors.warning;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    const filters = [
      'all',
      Inspection.statusDraft,
      Inspection.statusPending,
      Inspection.statusSynced,
      Inspection.statusFailed,
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Histórico de inspeções'),
        backgroundColor: AppColors.bgLight,
        actions: [
          IconButton(
            tooltip: 'Sincronizar inspeções',
            onPressed: () => _inspectionBloc.add(SyncPendingInspectionsEvent()),
            icon: const Icon(Icons.sync_rounded),
          ),
        ],
      ),
      body: BlocBuilder<InspectionBloc, InspectionState>(
        builder: (context, state) {
          if (state is InspectionLoadingState ||
              state is InspectionInitialState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InspectionErrorState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Não foi possível carregar o histórico.'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        _inspectionBloc.add(LoadInspectionHistoryEvent()),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final inspections = state is InspectionLoadedState
              ? state.inspections
              : const <Inspection>[];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: filters.map((filter) {
                    return ChoiceChip(
                      label: Text(
                        filter == 'all' ? 'Todos' : _statusLabel(filter),
                      ),
                      selected: _selectedStatus == filter,
                      onSelected: (_) => _filterInspections(filter),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: inspections.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma inspeção salva.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: inspections.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final inspection = inspections[index];
                          final color = _statusColor(inspection.status);
                          final canRetry =
                              inspection.status == Inspection.statusPending ||
                              inspection.status == Inspection.statusFailed;

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'OS ${inspection.workOrderId}',
                                        style: const TextStyle(
                                          color: AppColors.darkText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _statusLabel(inspection.status),
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  inspection.observation,
                                  style: const TextStyle(
                                    color: AppColors.bodyText,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Registrada em ${inspection.createdAt.toLocal()}',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                  ),
                                ),
                                if (inspection.errorMessage
                                    case final error?) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    error,
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                                if (canRetry) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: () => _inspectionBloc.add(
                                        RetryInspectionEvent(
                                          inspection.clientId,
                                        ),
                                      ),
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: Text(
                                        inspection.status ==
                                                Inspection.statusFailed
                                            ? 'Tentar novamente'
                                            : 'Reenviar',
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
