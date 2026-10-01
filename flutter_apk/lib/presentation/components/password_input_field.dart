import 'package:flutter/material.dart';

import 'package:inpecao_campo/core/utils/colors.dart';

import 'custom_input_field.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'SENHA',
      hint: 'Informe a sua senha',
      icon: Icons.lock_open,
      obscureText: !isVisible,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          size: 20,
          color: AppColors.bodyText,
        ),
      ),
    );
  }
}
