import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

class WorkOrdersFooter extends StatelessWidget {
  const WorkOrdersFooter({
    super.key,
    required this.visibleCount,
    required this.totalCount,
  });

  final int visibleCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$visibleCount exibidas • $totalCount no banco de dados local',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 14,
                  color: AppColors.success,
                ),
                SizedBox(width: 5),
                Text(
                  'Offline-First',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
