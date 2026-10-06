import 'package:flutter/material.dart';

import 'package:inspecao_campo/core/utils/colors.dart';

enum _ProfileMenuAction {
  notifications,
  support,
  preferences,
  switchAccount,
  logout,
}

String _profileInitials(String userName) {
  final names = userName.trim().split(RegExp(r'\s+'));
  if (names.isEmpty || names.first.isEmpty) {
    return 'U';
  }
  if (names.length == 1) {
    return names.first.substring(0, 1).toUpperCase();
  }
  return '${names.first.substring(0, 1)}${names.last.substring(0, 1)}'
      .toUpperCase();
}

class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    required this.userName,
    required this.role,
    required this.onLogout,
  });

  final String userName;
  final String role;
  final VoidCallback onLogout;

  String get _roleLabel => switch (role) {
    'field_technician' => 'Técnico de campo',
    'admin' => 'Administrador',
    _ => role,
  };

  void _handleAction(BuildContext context, _ProfileMenuAction action) {
    switch (action) {
      case _ProfileMenuAction.logout:
      case _ProfileMenuAction.switchAccount:
        onLogout();
      case _ProfileMenuAction.notifications:
        _showMessage(context, 'Notificações');
      case _ProfileMenuAction.support:
        _showMessage(context, 'Atendimento');
      case _ProfileMenuAction.preferences:
        _showMessage(context, 'Configurações');
    }
  }

  void _showMessage(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label ainda não está disponível.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ProfileMenuAction>(
      offset: const Offset(0, 52),
      position: PopupMenuPosition.under,
      tooltip: 'Abrir perfil',
      onSelected: (action) => _handleAction(context, action),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      itemBuilder: (context) => [
        PopupMenuItem<_ProfileMenuAction>(
          enabled: false,
          height: 70,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primarySoft,
                foregroundColor: AppColors.primary,
                child: Text(
                  _profileInitials(userName),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _roleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _ProfileMenuAction.notifications,
          child: _ProfileMenuRow(
            icon: Icons.notifications_none_rounded,
            label: 'Notificações',
          ),
        ),
        const PopupMenuItem(
          value: _ProfileMenuAction.support,
          child: _ProfileMenuRow(
            icon: Icons.support_agent_rounded,
            label: 'Atendimento',
          ),
        ),
        const PopupMenuItem(
          value: _ProfileMenuAction.preferences,
          child: _ProfileMenuRow(
            icon: Icons.settings_outlined,
            label: 'Configurações',
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _ProfileMenuAction.logout,
          child: _ProfileMenuRow(
            icon: Icons.logout_rounded,
            label: 'Sair',
            color: AppColors.danger,
          ),
        ),
      ],
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.darkText,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          _profileInitials(userName),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({
    required this.icon,
    required this.label,
    this.color = AppColors.darkText,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
