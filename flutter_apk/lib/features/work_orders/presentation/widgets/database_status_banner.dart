import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

class DatabaseStatusBanner extends StatelessWidget {
  const DatabaseStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.infoSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBAE6FD)),
        ),
        child: Row(
          children: [
            const Icon(Icons.storage_rounded, color: AppColors.info, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'BASE LOCAL ATIVA (HIVE DB) - Arraste p/ recarregar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.info,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
