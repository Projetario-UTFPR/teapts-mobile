import 'package:flutter/material.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 350),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/imagens/infinito_laranja_mid.png',
                    width: 150,
                  ),

                  const Gap(16),

                  const Text("Bem vindo de volta!", style: Styles.titles),

                  const Gap(32),
                  Styles.buildCustomInput(
                    label: 'E-mail',
                    hint: 'Digite seu e-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu e-mail';
                      }

                      final emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value);

                      if (!emailValid) {
                        return 'Digite um e-mail válido';
                      }

                      return null;
                    },
                  ),

                  const Gap(16),
                  Styles.buildCustomInput(
                    label: 'Senha',
                    hint: 'Digite sua senha',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Styles.widgetBlackCarret,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }

                      if (value.length < 6) {
                        return 'A senha deve ter no mínimo 6 caracteres';
                      }

                      return null;
                    },
                  ),

                  const Gap(16),
                  CheckboxListTile(
                    value: _rememberMe,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _rememberMe = value);
                    },
                    title: const Text(
                      'Lembre-se de mim',
                      style: Styles.normalText,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Styles.widgetYellow,
                    checkColor: Styles.widgetBlack,
                  ),

                  const Gap(16),

                  // Botão Fazer Login
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      title: 'Fazer login',
                      isLoading: _isLoading,
                      onPressed: _fazerLogin,
                    ),
                  ),

                  const Gap(16),

                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      title: 'Crie sua conta',
                      onPressed: () => context.go('/create-account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fazerLogin() async {
    setState(() => _isLoading = true);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      await AuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      final profiles = AuthService.professionalProfiles;

      if (profiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você não possui perfil profissional.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
