import 'package:flutter/material.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/document_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:gap/gap.dart';
import 'package:front_pi/services/activity_service.dart';

Future<bool?> addActivityPanel(BuildContext context, String patientId) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Styles.bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SuggestActivityForm(patientId: patientId),
    ),
  );
}

class SuggestActivityForm extends StatefulWidget {
  final String patientId;

  const SuggestActivityForm({super.key, required this.patientId});

  @override
  State<SuggestActivityForm> createState() => _SuggestActivityFormState();
}

class _SuggestActivityFormState extends State<SuggestActivityForm> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedFrequency = 'Semanal';
  final List<String> _frequencies = [
    'Diária',
    'Semanal',
    'Quinzenal',
    'Mensal',
    'Contínua',
  ];

  List<dynamic> _documentosDisponiveis = [];
  final List<String> _documentosSelecionados = [];
  bool _isLoadingDocs = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buscarDocumentosDoProntuario();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _buscarDocumentosDoProntuario() async {
    try {
      final docs = await DocumentService.getDocumentosDoProntuario(
        widget.patientId,
      );
      if (!mounted) return;
      setState(() {
        _documentosDisponiveis = docs;
        _isLoadingDocs = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingDocs = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar prontuário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  FrequencyDto _mapFrequencyToDto(String freq) {
    switch (freq) {
      case 'Diária':
        return FrequencyDto(
          times: 1,
          interval: 'day',
          durationValue: 1,
          durationUnit: 'month',
        );
      case 'Semanal':
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 1,
          durationUnit: 'month',
        );
      case 'Quinzenal':
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 2,
          durationUnit: 'month',
        );
      case 'Mensal':
        return FrequencyDto(
          times: 1,
          interval: 'month',
          durationValue: 3,
          durationUnit: 'month',
        );
      case 'Contínua':
        return FrequencyDto(
          times: 1,
          interval: 'day',
          durationValue: 12,
          durationUnit: 'month',
        );
      default:
        return FrequencyDto(
          times: 1,
          interval: 'week',
          durationValue: 1,
          durationUnit: 'month',
        );
    }
  }

  void _submitActivity() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final idProfissional = AuthService.professionalId;

    if (idProfissional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro: Profissional não identificado. Faça login novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final dto = CreateActivityDto(
      title: _titleController.text.trim(),
      professionalId: idProfissional,
      documentsIds: _documentosSelecionados,
      frequency: _mapFrequencyToDto(_selectedFrequency),
    );

    final service = ActivityService();
    final errorMessage = await service.createActivity(widget.patientId, dto);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atividade salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  //-------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Adicionar atividade', style: Styles.midSizeBold),

          const Gap(24),
          _buildTitleInput(),
          const Gap(24),
          _buildFrequencyDropdown(),
          const Gap(24),
          _buildDocumentSection(),
          const Gap(24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      decoration: Styles.textFieldDefault(labelText: 'Título'),
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFrequency,
      decoration: Styles.textFieldDefault(labelText: 'Frequência'),
      items: _frequencies
          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
          .toList(),
      onChanged: (val) => setState(() => _selectedFrequency = val!),
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vincular Documentos do Prontuário', style: Styles.midSize),
        const Gap(8),
        const Divider(height: 1),
        const Gap(8),

        if (_isLoadingDocs)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_documentosDisponiveis.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'O paciente não possui documentos no prontuário.',
              style: Styles.midSize,
            ),
          )
        else
          ..._documentosDisponiveis.map((doc) {
            final docId = doc['id'] as String;
            final docTitle = doc['title'] ?? 'Documento sem título';
            final isChecked = _documentosSelecionados.contains(docId);

            return CheckboxListTile(
              title: Text(docTitle, style: Styles.midSize),
              value: isChecked,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? checked) {
                setState(() {
                  if (checked == true) {
                    _documentosSelecionados.add(docId);
                  } else {
                    _documentosSelecionados.remove(docId);
                  }
                });
              },
            );
          }),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitActivity,
        style: Styles.buttonYellow,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Salvar', style: Styles.midSizeBold),
      ),
    );
  }
}
