import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inpecao_campo/core/utils/colors.dart';
import 'package:inpecao_campo/presentation/components/custom_button.dart';
import 'package:inpecao_campo/presentation/components/email_input_field.dart';
import 'package:inpecao_campo/presentation/components/password_input_field.dart';
import 'package:inpecao_campo/features/work_orders/presentation/home_page.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper para mensagens de aviso/erro
  void _showSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              _showSnackBar(
                message: 'Login realizado com sucesso!',
                backgroundColor: Colors.green,
              );

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }

            if (state is AuthErrorState) {
              _showSnackBar(
                message: state.message,
                backgroundColor: Colors.red,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const _LoginHeader(),
                  const SizedBox(height: 48),

                  EmailInputField(controller: _emailController),
                  const SizedBox(height: 24),
                  PasswordInputField(
                    controller: _passwordController,
                    isVisible: isPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => isPasswordVisible = !isPasswordVisible);
                    },
                  ),

                  const SizedBox(height: 30),

                  CustomButton(
                    text: "Entrar",
                    isLoading: isLoading,
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        _showSnackBar(
                          message: 'Por favor, preencha todos os campos.',
                          backgroundColor: Colors.orange,
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                        LoginSubmittedEvent(email: email, password: password),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  const _FooterSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 70),
        Icon(Icons.engineering_rounded, size: 48, color: AppColors.darkText),
        SizedBox(height: 12),
        Text(
          'Bem-vindo de volta!',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Informe suas credenciais para liberar o acesso",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.bodyText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Novo aqui?", style: TextStyle(color: AppColors.bodyText)),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Criar uma conta',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
