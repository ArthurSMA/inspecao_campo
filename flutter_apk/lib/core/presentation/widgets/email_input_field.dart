import 'package:flutter/material.dart';

import 'custom_input_field.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  const EmailInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'EMAIL',
      hint: 'Informe o seu e-mail',
      icon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
