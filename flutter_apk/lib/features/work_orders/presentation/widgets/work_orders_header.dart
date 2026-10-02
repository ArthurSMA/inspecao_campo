import 'package:flutter/material.dart';
import 'package:inpecao_campo/core/utils/colors.dart';

import 'work_orders_profile_avatar.dart';

class WorkOrdersHeader extends StatelessWidget {
  const WorkOrdersHeader({
    super.key,
    required this.userName,
    required this.onLogout,
    this.onSync,
  });

  final String userName;
  final VoidCallback onLogout;
  final VoidCallback? onSync;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ordens De Serviço',
              style:
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                    letterSpacing: -0.5,
                  ) ??
                  const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                    letterSpacing: -0.5,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
              onPressed: onSync,
              tooltip: 'Sincronizar',
            ),
          ),
          const SizedBox(width: 10),
          WorkOrdersProfileAvatar(userName: userName, onLogout: onLogout),
        ],
      ),
    );
  }
}
