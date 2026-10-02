import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/features/work_orders/domain/entities/work_order.dart';

class MapWorkOrderDetailsSheet extends StatelessWidget {
  const MapWorkOrderDetailsSheet({
    super.key,
    required this.workOrder,
    required this.onCopyCoordinates,
    required this.onRouteRequested,
  });

  final WorkOrder workOrder;
  final VoidCallback onCopyCoordinates;
  final VoidCallback onRouteRequested;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workOrder.code,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              workOrder.title,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              workOrder.address,
              style: const TextStyle(color: AppColors.bodyText, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              'Lat ${workOrder.latitude.toStringAsFixed(6)} • '
              'Long ${workOrder.longitude.toStringAsFixed(6)}',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCopyCoordinates,
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copiar coordenadas'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRouteRequested,
                icon: const Icon(Icons.alt_route_rounded),
                label: const Text('Traçar Rota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
