import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({
    super.key,
    required this.pendingCount,
    required this.isSyncing,
    required this.isConnected,
    required this.onSync,
  });

  final int pendingCount;
  final bool isSyncing;
  final bool? isConnected;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    final connectionLabel = switch (isConnected) {
      true => 'Conectado ao servidor',
      false => 'Sem conexão',
      null => 'Conexão não verificada',
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.cloud_sync_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connectionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fila: $pendingCount inspeções aguardando envio',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isSyncing ? null : onSync,
            tooltip: 'Sincronizar agora',
            icon: isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
