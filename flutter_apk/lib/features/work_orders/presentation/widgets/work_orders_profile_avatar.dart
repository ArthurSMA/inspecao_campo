import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

class WorkOrdersProfileAvatar extends StatelessWidget {
  const WorkOrdersProfileAvatar({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  final String userName;
  final VoidCallback onLogout;

  String get _initials {
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

  void _showProfileBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: Text(
                _initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inspetor de Campo',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.settings_outlined,
                color: AppColors.darkText,
              ),
              title: const Text(
                'Configurações',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onTap: () => Navigator.pop(modalContext),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.danger,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.pop(modalContext);
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfileBottomSheet(context),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.darkText,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          _initials,
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
