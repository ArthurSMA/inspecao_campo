import 'package:flutter/material.dart';
import 'package:inpecao_campo/pages/home_page.dart';
import 'package:inpecao_campo/services/auth_service.dart';

import '../../assets/colors/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para ler o que o usuário digita
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instância do serviço de autenticação
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função de Login conectada ao ApiService
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() => isLoading = true);

    bool sucesso = await _apiService.login(email, password);

    setState(() => isLoading = false);

    if (mounted) {
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login realizado com sucesso!'),
            backgroundColor: Colors.green,
            width: 200.0,
            padding: const .symmetric(horizontal: 4.0, vertical: 6.0),
            behavior: .floating,
            shape: RoundedRectangleBorder(borderRadius: .circular(10.0)),
          ),
        );
        // Exemplo de navegação para a próxima tela:
        // Navigator.of(context).pushReplacementNamed('/home');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E-mail ou senha incorretos.'),
            backgroundColor: Colors.red,
            width: 200.0,
            padding: const .symmetric(horizontal: 4.0, vertical: 8.0),
            behavior: .floating,
            shape: RoundedRectangleBorder(borderRadius: .circular(10.0)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        _LoginHeader(
                          bodyColor: AppColors.bodyText,
                          darkColor: AppColors.darkText,
                        ),
                        const SizedBox(height: 48),
                        _LoginFormFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          primaryColor: AppColors.primary,
                          darkColor: AppColors.darkText,
                          bodyColor: AppColors.bodyText,
                          borderColor: AppColors.border,
                          isPasswordVisible: isPasswordVisible,
                          onTogglePassword: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        _LoginButton(
                          btnColor: AppColors.darkText,
                          isLoading: isLoading,
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 10),
                        _FooterSection(
                          primaryColor: AppColors.primary,
                          bodyColor: AppColors.bodyText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Login Header
class _LoginHeader extends StatelessWidget {
  final Color darkColor, bodyColor;
  const _LoginHeader({required this.darkColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              size: 48,
              color: const Color(0xFF0F172A),
              // color: Color.fromARGB(255, 200, 218, 255), #c8daff
              Icons.engineering_rounded,
            ),
          ],
        ), //color: Color(0XFC8DAFF),),
        Center(
          child: Text(
            'Bem-vindo de volta!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: darkColor,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Informe suas credenciais para liberar o acesso",
            style: TextStyle(fontSize: 16, color: bodyColor, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// Login Form
class _LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Color primaryColor, darkColor, bodyColor, borderColor;
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;

  const _LoginFormFields({
    required this.emailController,
    required this.passwordController,
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("EMAIL"),
        _inputField(
          controller: emailController,
          icon: Icons.mail_outline_rounded,
          hint: "Informe o seu e-mail",
        ),
        const SizedBox(height: 24),
        _label("SENHA"),
        _inputField(
          controller: passwordController,
          icon: Icons.lock_open,
          hint: "Informe a sua senha",
          isPassword: true,
          suffix: IconButton(
            onPressed: onTogglePassword,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 20,
              color: bodyColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: bodyColor.withOpacity(0.8),
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkColor.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(color: darkColor, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: bodyColor.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: primaryColor, size: 22),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

// Login Button
class _LoginButton extends StatelessWidget {
  final Color btnColor;
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.btnColor,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Entrar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Icon(size: 26, Icons.arrow_right_alt_rounded),
                ],
              ),
      ),
    );
  }
}

// Widget Footer
class _FooterSection extends StatelessWidget {
  final Color primaryColor, bodyColor;
  const _FooterSection({required this.primaryColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Novo aqui?", style: TextStyle(color: bodyColor)),
        TextButton(
          onPressed: () {},
          child: Text(
            'Criar uma conta',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
