import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

class WorkOrdersFilterChips extends StatelessWidget {
  const WorkOrdersFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final filters = const <Map<String, String>>[
      {'label': 'Todas', 'value': 'all'},
      {'label': 'Abertas', 'value': 'open'},
      {'label': 'Em andamento', 'value': 'in_progress'},
      {'label': 'Concluídas', 'value': 'done'},
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['value'];

          return ChoiceChip(
            label: Text(filter['label']!),
            selected: isSelected,
            onSelected: (_) => onFilterSelected(filter['value']!),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.darkText,
            ),
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          );
        },
      ),
    );
  }
}
