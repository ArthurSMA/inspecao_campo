import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

import 'app_profile_avatar.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.userName,
    required this.userRole,
    required this.onLogout,
    this.onSync,
  });

  final String title;
  final String userName;
  final String userRole;
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
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
                letterSpacing: -0.5,
              ),
            ),
          ),
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
          AppProfileAvatar(
            userName: userName,
            role: userRole,
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }
}
