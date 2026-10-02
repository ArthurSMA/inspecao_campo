import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({
    super.key,
    required this.completed,
    required this.openCount,
    this.dailyGoal = 5,
  });

  final int completed;
  final int openCount;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'Concluídas',
            value: '$completed',
            detail: 'Meta diária: $dailyGoal OS',
            icon: Icons.task_alt_rounded,
            color: AppColors.success,
            background: AppColors.successSoft,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Em aberto',
            value: '$openCount',
            detail: 'Ordens para atender',
            icon: Icons.assignment_late_outlined,
            color: AppColors.warning,
            background: AppColors.warningSoft,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
