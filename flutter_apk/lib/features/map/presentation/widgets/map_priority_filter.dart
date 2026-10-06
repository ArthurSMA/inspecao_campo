import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class MapPriorityFilter extends StatelessWidget {
  const MapPriorityFilter({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _PriorityChip(
            label: 'Todas',
            value: 'all',
            selected: selectedPriority == 'all',
            onSelected: onPrioritySelected,
          ),
          _PriorityChip(
            label: 'Alta',
            value: 'high',
            selected: selectedPriority == 'high',
            onSelected: onPrioritySelected,
          ),
          _PriorityChip(
            label: 'Média',
            value: 'medium',
            selected: selectedPriority == 'medium',
            onSelected: onPrioritySelected,
          ),
          _PriorityChip(
            label: 'Baixa',
            value: 'low',
            selected: selectedPriority == 'low',
            onSelected: onPrioritySelected,
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final String value;
  final bool selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.darkText,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}
