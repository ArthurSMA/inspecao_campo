import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({
    super.key,
    required this.onAllWorkOrders,
    required this.onHistory,
  });

  final VoidCallback onAllWorkOrders;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAccessTile(
            title: 'Todas as OS',
            subtitle: 'Consultar serviços',
            icon: Icons.assignment_outlined,
            onTap: onAllWorkOrders,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAccessTile(
            title: 'Histórico',
            subtitle: 'Inspeções salvas',
            icon: Icons.history_rounded,
            onTap: onHistory,
          ),
        ),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
