import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class WorkOrdersSearchBar extends StatelessWidget {
  const WorkOrdersSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, _) {
        final hasText = value.text.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkText.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search_rounded, color: AppColors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por OS, ativo ou endereço...',
                      hintStyle: TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
                if (hasText)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: IconButton(
                      onPressed: onClear,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.muted,
                      ),
                      splashRadius: 18,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
