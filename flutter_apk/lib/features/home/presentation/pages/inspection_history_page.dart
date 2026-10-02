import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/work_orders/data/database/work_orders_database.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/inspection.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  late final AppDatabase _database;
  late Future<List<Inspection>> _inspections;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _inspections = _database.getInspections();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Histórico de inspeções'),
        backgroundColor: AppColors.bgLight,
      ),
      body: FutureBuilder<List<Inspection>>(
        future: _inspections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar o histórico.'),
            );
          }

          final inspections = snapshot.data ?? const <Inspection>[];
          if (inspections.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma inspeção salva.',
                style: TextStyle(color: AppColors.muted),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: inspections.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              final color = _statusColor(inspection.status);
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
                    if (inspection.errorMessage case final error?) ...[
                      const SizedBox(height: 6),
                      Text(
                        error,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
