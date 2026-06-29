import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/components/buttons/secondary_button.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscurePassword = true;
  var _obscureConfirmPassword = true;

  int _passwordStrength(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 350),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/imagens/infinito_laranja_mid.png',
                    width: 150,
                  ),
                  const Gap(16),
                  const Text('Crie sua conta', style: Styles.titles),
                  const Gap(32),

                  Styles.buildCustomInput(
                    label: 'Nome',
                    hint: 'Digite seu nome',
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),

                  const Gap(16),

                  Styles.buildCustomInput(
                    label: 'E-mail',
                    hint: 'Digite seu e-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Obrigatório';
                      if (!v.contains('@')) return 'Digite um email válido';
                      return null;
                    },
                  ),

                  const Gap(16),

                  Styles.buildCustomInput(
                    label: 'Criar senha',
                    hint: 'Digite sua senha',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Styles.widgetBlackCarret,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Obrigatório';
                      if (v.length < 8) return 'Mínimo 8 caracteres';
                      return null;
                    },
                  ),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _passwordController,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _passwordStrength(value.text) / 4,
                            backgroundColor: Colors.grey[300],
                            color: Styles.widgetYellow,
                            minHeight: 6,
                          ),
                        ),
                      );
                    },
                  ),

                  const Gap(16),

                  Styles.buildCustomInput(
                    label: 'Repita a senha',
                    hint: 'Digite sua senha novamente',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Styles.widgetBlackCarret,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Obrigatório';
                      if (v != _passwordController.text)
                        return 'As senhas não coincidem';
                      return null;
                    },
                  ),

                  const Gap(32),

                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      title: 'Criar Conta',
                      isLoading: _isLoading,
                      onPressed: _criarConta,
                    ),
                  ),

                  const Gap(16),

                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      title: 'Já tenho uma conta',
                      onPressed: () => context.go('/login'),
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

  Future<void> _criarConta() async {
    setState(() => _isLoading = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await AuthService.createAccount(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/login');
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
