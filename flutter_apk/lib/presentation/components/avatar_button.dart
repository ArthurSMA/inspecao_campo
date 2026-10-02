import 'package:flutter/material.dart';
import 'package:inpecao_campo/core/utils/colors.dart';

class ProfileAvatarMenu extends StatelessWidget {
  const ProfileAvatarMenu({
    super.key,
    required this.userName,
    required this.onLogout,
    this.unreadNotificationsCount = 4,
  });

  final String userName;
  final VoidCallback onLogout;
  final int unreadNotificationsCount;

  String get _initials {
    final names = userName.trim().split(' ');
    if (names.isEmpty || names.first.isEmpty) return 'U';
    if (names.length == 1) return names.first[0].toUpperCase();
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      // Deslocamento para alinhar o card flutuante abaixo e levemente à esquerda do avatar
      offset: const Offset(-20, 50),
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Customização dos itens do menu
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'notifications',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.notifications_outlined, color: AppColors.darkText, size: 22),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Notificações',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              if (unreadNotificationsCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE866), // Amarelo do print
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unreadNotificationsCount',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'support',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.chat_bubble_outline_rounded, color: AppColors.darkText, size: 22),
              SizedBox(width: 14),
              Text(
                'Atendimento',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'preferences',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.person_outline_rounded, color: AppColors.darkText, size: 22),
              SizedBox(width: 14),
              Text(
                'Preferências',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'switch_accounts',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.sync_alt_rounded, color: AppColors.darkText, size: 22),
              SizedBox(width: 14),
              Text(
                'Trocar de contas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 16),
        PopupMenuItem<String>(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.darkText, size: 22),
              SizedBox(width: 14),
              Text(
                'Sair',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'logout':
            onLogout();
            break;
          case 'notifications':
            // Ação Notificações
            break;
          case 'preferences':
            // Ação Preferências
            break;
          case 'support':
            // Ação Atendimento
            break;
        }
      },
      // Widget que aciona o Menu (Avatar com badge amarela)
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.darkText,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (unreadNotificationsCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE866), // Amarelo do estilo do print
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadNotificationsCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}