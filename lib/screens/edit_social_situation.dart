import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:front_pi/screens/pts/view/social_situation_notifier.dart';
import 'package:gap/gap.dart';
import 'package:front_pi/config/app_config.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/mainAppBar.dart';
import 'package:front_pi/components/buttons/primary_button.dart';

class EditSocialSituationPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String socialSituation;

  const EditSocialSituationPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.socialSituation,
  });

  @override
  State<EditSocialSituationPage> createState() =>
      _EditSocialSituationPageState();
}

class _EditSocialSituationPageState extends State<EditSocialSituationPage> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.socialSituation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A situação social não pode estar vazia.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = AuthService.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('Sessão inválida. Por favor, faça login novamente.');
      }

      final url =
          '${AppConfig.baseUrl}/v1/pts/${widget.patientId}/social-situation/update';

      final dio = Dio();
      await dio.patch(
        url,
        data: {'socialSituation': _controller.text},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Situação social atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        PtsSocialSituationNotifier.instance.updateSocialSituation(
          _controller.text,
        );

        Navigator.of(context).pop();
      }
    } on DioException catch (e) {
      if (mounted) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Erro no servidor.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: MainAppBar(title: 'Editar situação social', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paciente: ${widget.patientName}', style: Styles.titles),

            const Gap(16),
            Styles.buildCustomInput(
              label: 'Situação Social',
              hint: 'Digite a nova situação social...',
              controller: _controller,
              isMultiline: true,
            ),

            const Gap(32),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                title: 'Guardar Alterações',
                isLoading: _isLoading,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
